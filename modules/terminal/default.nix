# The default terminal setup I have
{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  options = {
    bundles.terminal = {
      enable = lib.mkEnableOption "Enables my terminal environment";
    };
  };

  config = lib.mkIf config.bundles.terminal.enable {
    home-manager.users.kuglimon =
      { ... }:
      {
        imports = [
          {
            # Home-manager has programs that can configure all of these through
            # a DSL, but I think that's ultimately bad for you.
            #
            # You should learn how to use the underlying tools and how to
            # configure them, it similar to using GUI apps for terminal apps.
            # There are a crap ton of other reasons:
            #
            # * Your friends are probably not using NixOS
            # * Maybe you have a mac and don't use nix there
            # * Your coworkers can't help you with issues
            # * You cannot help your coworkers
            # * Likely you'll never really learn from mistakes
            # * Googling for configuration is multiple layers
            home.file.".aliases".source = ../../dotfiles/aliases;

            home.file.".ssh/config".source = ../../dotfiles/ssh/config;

            home.file.".gemrc".source = ../../dotfiles/gemrc;

            home.file.".git_template".source = ../../dotfiles/git_template;
            home.file.".gitconfig".source = ../../dotfiles/gitconfig;
            home.file.".gitconfig-work".source = ../../dotfiles/gitconfig-work;
            home.file.".gitignore".source = ../../dotfiles/gitignore;
            home.file.".gitmessage".source = ../../dotfiles/gitmessage;

            home.file.".gnupg/gpg-agent.conf".source = ../../dotfiles/gnupg/gpg-agent.conf;

            home.file.".psqlrc".source = ../../dotfiles/psqlrc;
            home.file.".rspec".source = ../../dotfiles/rspec;

            home.file.".local/bin" = {
              source = ../../dotfiles/bin;
              recursive = true;
              executable = true;
            };

            home.file.".tmux.conf".source = ../../dotfiles/tmux.conf;
            home.file.".config/tmux" = {
              source = ../../dotfiles/tmux;
              recursive = true;
            };

            home.file.".config/nvim/init.lua".source = ../../dotfiles/nvim/init.lua;
            home.file.".config/nvim/lua" = {
              source = ../../dotfiles/nvim/lua;
              recursive = true;
            };

            home.file.".zsh/functions" = {
              source = ../../dotfiles/zsh/functions;
              recursive = true;
            };
            home.file.".zshenv".source = ../../dotfiles/zshenv;
            home.file.".zshrc".source = ../../dotfiles/zshrc;

            home.file.".config/starship.toml".source = ../../dotfiles/starship.toml;

            home.file.".config/alacritty/alacritty.toml".source = ../../dotfiles/alacritty/alacritty.toml;
            home.file.".config/alacritty/override.toml".source = ../../dotfiles/alacritty/linux.toml;
            home.file.".config/alacritty/catppuccin/catppuccin-mocha.toml".source =
              "${pkgs.alacritty-theme}/catppuccin_mocha.toml";
          }
        ];
      };

    console.keyMap = "fi";

    users.users.kuglimon = {
      packages = with pkgs; [
        # the 'bash' package is a minimal bash installation meant for scripts and
        # automation. We want the full package for interactive use.
        bashInteractive
        btrfs-progs

        dosfstools
        file
        qemu
        ghostscript
        rclone

        # For debugging failing nix builds
        cntr

        # TODO(tatu): Is there a better way than just referencing inputs? Maybe
        # there's a way to drop the system at least.
        inputs.rojekti.packages.${system}.rojekti
      ];
    };

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
  };
}
