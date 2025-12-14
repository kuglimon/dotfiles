# Configures my GUI experience.
{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    bundles.gui = {
      enable = lib.mkEnableOption "Enables GUI";
    };
  };

  config = lib.mkIf config.bundles.gui.enable {
    home-manager.users.kuglimon =
      { ... }:
      {
        imports = [
          {
            home.file.".config/hypr/hyprland.conf".source = ../../dotfiles/hypr/hyprland.conf;
            home.file.".config/hypr/hyprpaper.conf".source = ../../dotfiles/hypr/hyprpaper.conf;

            home.file.".config/waybar" = {
              source = ../../dotfiles/waybar;
              recursive = true;
            };

            home.file."Images" = {
              source = ../../dotfiles/wallpapers;
              recursive = true;
            };

            home.file.".config/rofi" = {
              source = ../../dotfiles/rofi;
              recursive = true;
            };

            home.file.".config/dunst/dunstrc".source = ../../dotfiles/dunst/dunstrc;

            # Mangohud frame limiting goes crazy on the new Fallout 4 update, limiting fps
            # to 60 causes the game to run at like 15fps. This config fixes that.
            #
            # To use this add the following for Fallout 4 launch options:
            #   MANGOHUD_CONFIG=fps_limit=60 DXVK_CONFIG_FILE=/home/kuglimon/.config/game_hacks/fallout4.conf mangohud %command%
            home.file.".config/game_hacks/fallout4.conf".source = ../../dotfiles/game_hacks/fallout4.conf;

            # Performance in Last Epoch is ass, maybe this fixes it
            # WINE_CPU_TOPOLOGY=6:0,1,2,3,4,5 DXVK_CONFIG_FILE=/home/kuglimon/.config/game_hacks/last_epoch.conf mangohud %command%
            home.file.".config/game_hacks/last_epoch.conf".source = ../../dotfiles/game_hacks/last_epoch.conf;

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
            };

            # Add the default connection for virt-manager
            dconf.settings = {
              "org/virt-manager/virt-manager/connections" = {
                autoconnect = [ "qemu:///system" ];
                uris = [ "qemu:///system" ];
              };
            };
          }
        ];
      };

    services.libinput = {
      mouse = {
        # Disable right + left click executing middle click. This is pure cancer
        # when gaming.
        middleEmulation = false;
      };
    };

    # Still need to set password with 'passwd' after creation.
    users.users.kuglimon =
      let
        toggle-rofi = pkgs.writeShellApplication {
          name = "toggle-rofi";

          runtimeInputs = with pkgs; [
            killall
            rofi
            procps
          ];

          text = ''
            if pgrep -x rofi; then
                killall rofi
            else
                rofi -show drun
            fi
          '';
        };
      in
      {
        packages = with pkgs; [
          discord
          dunst
          file
          flameshot
          ghostscript
          keepassxc
          newsboat
          pulsemixer
          spotify

          # hyprland stuff
          hyprpaper
          waybar
          rofi
          toggle-rofi

          # for reverse engineering
          ghidra
        ];
      };

    # TODO(tatu): Why does NixOS recommend enabling this?
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    fonts.packages = with pkgs; [
      nerd-fonts.fira-mono
    ];

    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    # Naming on this service is rather confusing. It's not just tied to wayland.
    services.xserver = {
      enable = true;
      autorun = false;

      displayManager = {
        # Login to tty. Based on reddit comments I decided to finally try
        # logging in to display manager instead of tty. Many of them don't work
        # on wayland and the one that I finally got working (ssdm) has multiple
        # other issues like mouse and keyboard being completely dead once
        # hyprland had started. Only way to fix it was to reconnect them, not
        # even changing modes on the keyboard would make it reconnect. So yeah,
        # fuck that noise, tty still works. One of the questions in reddit was
        # that can't you just ctrl+alt+fx to another termina, well fucking
        # obviously not right away if your keyboard doesn't work :D
        startx.enable = true;
      };

      # Otherwise startX display manager will try to boot into xterm
      excludePackages = with pkgs; [
        xterm
      ];

      # TODO(tatu): Should move this, hardware dependent
      videoDrivers = [ "nvidia" ];
    };

    # Install extensions for all profiles. This seemed like a way simpler solution
    # since I have no idea what the hell NUR even is at this point. Randomly
    # adding in a bunch of user managed repositories sure doesn't sound safe.
    #
    # home-manager managed extensions require you to manually enable them after
    # installation. Systemwide ones will work just fine.
    programs.firefox = {
      enable = true;

      policies = {
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        # DNSOverHTTPS = true;

        # Preferences are poorly documented, best bet is to try to google and/or
        # search them from 'about:config'. You can also try searching the html
        # elements in the preferences page and then search them from firefox
        # sources.
        #
        # Many of the settings are from:
        #   https://github.com/arkenfox/user.js/blob/master/user.js
        #
        # XXX(tatu): These are prone to break. Just the damn dark mode setting has
        # seen three different user preferences during three years. These will
        # also fail silently, I'm not sure if there's a way to check if a
        # preference exists.
        # XXX(tatu): These values are just some random ass strings and integers
        # scattered around firefox codebase. They can change at will and I'm
        # guessing there's no guarantee that they'll ever stay stable. Good luck.
        Preferences = {
          "browser.contentblocking.category" = "strict";

          # This should enable dark-mode everywhere and let websites know dark
          # pages are preferred.
          "browser.theme.toolbar-theme" = 0;
          "browser.theme.content-theme" = 0;
          "devtools.theme" = "dark";

          # Enables middle click scrolling
          "general.autoScroll" = true;

          # Restore previously closed tabs on startup
          "browser.startup.page" = 3;

          # Highlight all matches on searches
          "findbar.highlightAll" = true;

          # XXX(tatu): Nobel prize winning guess that this might not work on osx.
          # Always show scroll bars
          "widget.gtk.overlay-scrollbars.enabled" = true;

          # Don't show a warning when visiting 'about:config'
          "browser.aboutConfig.showWarning" = true;

          # Don't show any sponsored content
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

          # Clearing default sites, just in-case Mozilla puts some other content
          # there. This does not block my own additions.
          "browser.newtabpage.activity-stream.default.sites" = "";

          # Disable addon recommendations (uses google analytics).
          "extensions.getAddons.showPane" = false;

          # Disable recommended extensions and themes pane
          "extensions.htmlaboutaddons.recommendations.enabled" = false;

          # Don't send telemetry data
          "datareporting.healthreport.uploadEnabled" = false;

          # FIXME(tatu): Parsing these settings by hand is ass. Maybe make a nix
          # pkgs that parses these and exposes all the values? This might even
          # enable LSP over them.
        };

        ExtensionSettings = {
          # Block all other addons except the ones defined here
          "*".installation_mode = "blocked";
          # uBlock Origin:
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          # Vimium:
          "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
            installation_mode = "force_installed";
          };
        };
      };
    };

    bundles.unfreePackages = [
      "discord"
      "spotify"
    ];
  };
}
