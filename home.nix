{ pkgs, ... }:

{
  home.username = "kuglimon";
  home.homeDirectory = "/home/kuglimon";

  # Home-manager has programs that can configure all of these through a DSL,
  # but I think that's ultimately bad for you.
  #
  # You should learn how to use the underlying tools and how to configure them,
  # it similar to using GUI apps for terminal apps. There are a crap ton of
  # other reasons:
  #
  # * Your friends are probably not using NixOS
  # * Maybe you have a mac and don't use nix there
  # * Your coworkers can't help you with issues
  # * You cannot help your coworkers
  # * Likely you'll never really learn from mistakes
  # * Googling for configuration is multiple layers
  home.file.".aliases".source = ./aliases;

  home.file.".ssh/config".source = ./ssh/config;

  home.file.".gemrc".source = ./gemrc;

  home.file.".git_template".source = ./git_template;
  home.file.".gitconfig".source = ./gitconfig;
  home.file.".gitignore".source = ./gitignore;
  home.file.".gitmessage".source = ./gitmessage;

  home.file.".psqlrc".source = ./psqlrc;
  home.file.".rspec".source = ./rspec;

  home.file.".local/bin" = {
    source = ./bin;
    recursive = true;
    executable = true;
  };

  home.file.".tmux.conf".source = ./tmux.conf;
  home.file.".config/tmux" = {
    source = ./tmux;
    recursive = true;
  };

  home.file.".config/nvim/init.lua".source = ./nvim/init.lua;
  home.file.".config/nvim/lua" = {
    source = ./nvim/lua;
    recursive = true;
  };

  home.file.".zsh/functions" = {
    source = ./zsh/functions;
    recursive = true;
  };
  home.file.".zshenv".source = ./zshenv;
  home.file.".zshrc".source = ./zshrc;

  home.file.".config/alacritty/alacritty.toml".source = ./alacritty/alacritty.toml;
  home.file.".config/alacritty/override.toml".source = ./alacritty/linux.toml;

  home.file.".xinitrc".source = ./xinitrc;
  home.file.".config/i3/config".source = ./i3/config;

  home.file.".config/polybar/config".source = ./polybar/config;
  home.file.".config/polybar/launch.sh" = {
    source = ./polybar/launch.sh;
    executable = true;
  };

  home.file.".config/rofi" = {
    source = ./rofi;
    recursive = true;
  };

  home.file.".config/dunst/dunstrc".source = ./dunst/dunstrc;

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  # Only the profiles are created here while the systemwide configuration
  # handles the rest. These profiles should match anyways. 'default-release' is
  # the default profile and 'private' is for sandbox browser for webdev testing.
  #
  # Two profiles are needed because firefox sets the X11 windows class name on
  # profile basis and we create special keybinds for default-release and private
  # profiles. If I remember correctly one could not pass class for default,
  # hence 'default-release' was used. I have no memory why I named it release,
  # probably copy-pasta from some unrelated article.
  #
  # For further reference check 'i3/config' and 'configuration.nix'.
  programs.firefox = {
    enable = true;

    profiles = {
      default-release = {
        id = 0;
        name = "default-release";
        isDefault = true;
      };

      private = {
        id = 1;
        name = "private";
        isDefault = false;
      };
    };
  };
}
