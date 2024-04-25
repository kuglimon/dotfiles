{ config, pkgs, ... }:

{
  home.username = "kuglimon";
  home.homeDirectory = "/home/kuglimon";

  home.stateVersion = "23.11"
  programs.home-manager.enable = true;
}
