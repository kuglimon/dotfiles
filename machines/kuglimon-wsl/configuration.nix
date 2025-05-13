{
  self,
  inputs,
  lib,
  pkgs,
  ...
}: {
  # TODO(tatu): maybe is should just drop home-manager completely. I use it for
  # like firefox profiles and that's it. There's probably another way to install
  # dotfiles without it.
  imports = with inputs; [
    home-manager.nixosModules.home-manager
  ];

  # home-manager options
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.kuglimon = {...}: {
    imports = [
      ../../modules/home-manager/common
      ./home.nix
    ];
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
    ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # These are based on Arch Linux defaults:
  #   https://gitlab.archlinux.org/archlinux/packaging/packages/filesystem/-/blob/main/sysctl
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 524288;
    "fs.inotify.max_user_instances" = 1024;

    # Games are known to exhaust this:
    #   https://lists.archlinux.org/archives/list/arch-dev-public@lists.archlinux.org/thread/5GU7ZUFI25T2IRXIQ62YYERQKIPE3U6E/
    "vm.max_map_count" = 1048576;
  };

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

  # All my development needs
  bundles.development.enable = true;

  # Still need to set password with 'passwd' after creation.
  users.users.kuglimon = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "libvirtd" # Enables virt-manager to connect to kvm?
      "docker"
    ];

    createHome = true;
    packages = with pkgs; [
      # the 'bash' package is a minimal bash installation meant for scripts and
      # automation. We want the full package for interactive use.
      bashInteractive

      # Enable back once tests don't fail and the damn app doesn't register it
      # as default app for everything.
      # calibre
      dosfstools
      file
      rclone

      # For debugging failing nix builds
      cntr

      # Not sure if there's a cleaner way to reference packages from custom
      # repositories.
      inputs.rojekti.packages.${system}.rojekti
    ];
  };

  virtualisation.docker.enable = true;
  users.defaultUserShell = pkgs.zsh;
  programs.git.lfs.enable = true;

  # If GPG complains about missing pinentry then try rebooting the machine.
  # There's likely some configuration error, too lazy to debug it now.
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
    enableSSHSupport = true;
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}
