{ config, pkgs, ... }:

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

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
