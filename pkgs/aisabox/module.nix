# claude-vm/module.nix
#
# NixOS module for the Claude Code sandbox VM.
# The claude-vm launcher script imports this automatically.
# You don't need to reference this from per-project vm.nix files.
#
# Required: set claude-vm.user to match your host username.
#
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.claude-vm;
in
{
  options.claude-vm = {
    user = lib.mkOption {
      type = lib.types.str;
      description = "Username inside the VM (should match your host user)";
    };

    uid = lib.mkOption {
      type = lib.types.int;
      default = 1000;
      description = "UID (should match your host UID)";
    };

    shell = lib.mkOption {
      type = lib.types.package;
      default = pkgs.zsh;
      description = "Login shell";
    };

    memory = lib.mkOption {
      type = lib.types.int;
      default = 4096;
      description = "VM memory in MB";
    };

    cores = lib.mkOption {
      type = lib.types.int;
      default = 4;
      description = "VM CPU cores";
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Additional packages (language toolchains, etc.)";
    };

    idePort = lib.mkOption {
      type = lib.types.int;
      default = 61022;
      description = "Fixed port for claudecode.nvim WebSocket forwarding";
    };

    enableIdeForward = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable socat WebSocket forwarding for host-side neovim";
    };
  };

  config = {
    # ── User ──────────────────────────────────────────────────────
    users.users.${cfg.user} = {
      isNormalUser = true;
      uid = cfg.uid;
      group = cfg.user;
      extraGroups = [ "wheel" ];
      home = "/home/${cfg.user}";
      shell = cfg.shell;
    };
    users.groups.${cfg.user}.gid = cfg.uid;

    # ── Packages ──────────────────────────────────────────────────
    environment.systemPackages =
      with pkgs;
      [
        claude-code
        git
        ripgrep
        fd
        curl
        jq
      ]
      ++ lib.optional cfg.enableIdeForward pkgs.socat
      ++ cfg.extraPackages;

    # ── nixos-shell mounts ────────────────────────────────────────
    nixos-shell.mounts = {
      mountHome = false;
      mountNixProfile = false;
      cache = "none";
    };

    # ── VM resources ──────────────────────────────────────────────
    virtualisation.memorySize = cfg.memory;
    virtualisation.cores = cfg.cores;
    virtualisation.diskSize = 10 * 1024;

    # ── Networking ────────────────────────────────────────────────
    networking.firewall.enable = false;

    # ── Auto-login ────────────────────────────────────────────────
    services.getty.autologinUser = lib.mkForce cfg.user;

    # ── Shell environment ─────────────────────────────────────────
    programs.zsh.enable = lib.mkIf (cfg.shell == pkgs.zsh) true;

    systemd.tmpfiles.rules = [
      "f /home/${cfg.user}/.zshrc 0644 ${cfg.user} ${cfg.user} -"
    ];

    environment.loginShellInit = ''
      cd /project 2>/dev/null || true
      claude
    '';

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "claude-code"
      ];

    # ── Protect .git read-only ────────────────────────────────────
    systemd.services.protect-git = {
      description = "Remount .git read-only";
      wantedBy = [ "multi-user.target" ];
      after = [ "local-fs.target" ];
      path = [ pkgs.util-linux ];
      unitConfig.ConditionPathIsDirectory = "/project/.git";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStartPre = "${pkgs.util-linux}/bin/mount --bind /project/.git /project/.git";
        ExecStart = "${pkgs.util-linux}/bin/mount -o remount,bind,ro /project/.git";
      };
    };

    # ── Secrets handling ──────────────────────────────────────────
    systemd.services.setup-secrets = {
      description = "Copy API key from 9p mount to secure tmpfs";
      wantedBy = [ "multi-user.target" ];
      after = [ "local-fs.target" ];
      unitConfig.ConditionPathExists = "/run/secrets/api-key";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "setup-secrets" ''
          mkdir -p /run/claude-secrets
          cp /secrets/api-key /run/claude-secrets/api-key
          chown ${cfg.user}:${cfg.user} /run/claude-secrets/api-key
          chmod 600 /run/claude-secrets/api-key
        '';
      };
    };

    # ── IDE WebSocket forwarding (optional) ───────────────────────
    systemd.services.claude-ide-forward = lib.mkIf cfg.enableIdeForward {
      description = "Forward claudecode.nvim WebSocket to host";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.socat}/bin/socat TCP-LISTEN:${toString cfg.idePort},bind=127.0.0.1,fork,reuseaddr TCP:10.0.2.2:${toString cfg.idePort}";
        Restart = "always";
        User = cfg.user;
      };
    };

    systemd.services.claude-setup = {
      description = "Initialize Claude Code config";
      wantedBy = [ "multi-user.target" ];
      after = [ "local-fs.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = cfg.user;
        ExecStart = pkgs.writeShellScript "claude-setup" ''
          # Skip onboarding
          cat > /home/${cfg.user}/.claude.json <<EOF
          {
            "numStartups": 1,
            "hasCompletedOnboarding": true,
            "lastOnboardingVersion": "2.1.77",
            "voiceNoticeSeenCount": 1,
            "lastReleaseNotesSeen": "2.1.77",
            "projects": {
              "/project": {
                "hasTrustDialogAccepted": true,
                "allowedTools": []
              }
            },
            "theme": "dark"
          }
          EOF
        '';
      };
    };
  };
}
