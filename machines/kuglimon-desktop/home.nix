{ pkgs, ... }:

{
  home.username = "kuglimon";
  home.homeDirectory = "/home/kuglimon";

  home.file.".xinitrc".source = ../../dotfiles/xinitrc;
  home.file.".config/i3/config".source = ../../dotfiles/i3/config;

  home.file.".config/polybar/config.ini".source = ../../dotfiles/polybar/config.ini;
  home.file.".config/polybar/launch.sh" = {
    source = ../../dotfiles/polybar/launch.sh;
    executable = true;
  };

  home.file.".config/rofi" = {
    source = ../../dotfiles/rofi;
    recursive = true;
  };

  home.file."Images" = {
    source = ../../dotfiles/wallpapers;
    recursive = true;
  };

  home.file.".config/dunst/dunstrc".source = ../../dotfiles/dunst/dunstrc;

  # Mangohud frame limiting goes crazy on the new Fallout 4 update, limiting fps
  # to 60 causes the game to run at like 15fps. This config fixes that.
  #
  # To use this add the following for Fallout 4 launch options:
  #   MANGOHUD_CONFIG=fps_limit=60 DXVK_CONFIG_FILE=/home/kuglimon/.config/game_hacks/fallout4.conf mangohud %command%
  home.file.".config/game_hacks/fallout4.conf".source = ../../dotfiles/game_hacks/fallout4.conf;

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

  home.pointerCursor = {
    # size = 40;
    package = pkgs.capitaine-cursors;
    name = "capitaine-cursors";

    x11.enable = true;
  };

  # Add the default connection for virt-manager
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  xsession.enable = true;

  home.stateVersion = "23.11";
}
