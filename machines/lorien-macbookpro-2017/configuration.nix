{ self, config, lib, pkgs, ... }:

{
  services.nix-daemon.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    interval.Day = 1;
    options = "--delete-older-than 1d";
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "discord"
      "spotify"
    ];

  # Still need to set password with 'passwd' after creation.
  users.users.kuglimon = {
    createHome = true;
    home = /Users/kuglimon;

    packages = with pkgs; [
       alacritty-theme
       bash
       bat
       cargo
       fzf
       gcc
       (lib.hiPrio binutils) # This is just so I don't have to install xcode
       ghostscript
       git
       git-crypt
       go
       gnupg
       imagemagick
       jq
       killall
       newsboat
       nodejs_latest
       neovim
       rclone
       ripgrep
       rustc
       tmux
       tree
       unzip
       zsh
       zsh-completions
    ];
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = ["FiraMono"]; })
  ];

  environment = {
    shells = [ pkgs.zsh pkgs.bashInteractive ];
    systemPackages = with pkgs; [
      # GUI apps
      alacritty
      # botan3 doesn't compile on my old intel macbook, botan2 does
      (keepassxc.override { botan3 = pkgs.botan2; })
      discord
      spotify

      self.packages.${pkgs.system}.firefox-darwin
    ];
  };

  # FIXME(tatu): figure out a better way to expose keepassxc-cli, maybe overlays
  # can be used for this?
  #
  # Initialize the nix-daemon and link to keepassxc
  programs.zsh.enable = true;
  programs.zsh.shellInit = ''
    # Nix
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
    export PATH="$HOME/Applications/Nix Apps/KeePassXC.app/Contents/MacOS:$PATH"
    # End Nix
  '';

  system = {
    stateVersion = 4;

    defaults = {
      trackpad = {
        # One tap to click
        #
        # These options do nothing:
        # "com.apple.mouse.tapBehavior" = 1;
        Clicking = true;
      };

      NSGlobalDomain = {
        # Disable natural scrolling, feels awful
        "com.apple.swipescrolldirection" = false;
      };

      CustomUserPreferences = {
        "com.apple.AppleMultitouchTrackpad" = {
          # Only this setting correctly sets secondary click from right corner.
          # Neither of these work:
          #
          # "com.apple.trackpad.trackpadCornerClickBehavior" = 1;
          # trackpad.TrackpadRightClick = true;
          TrackpadCornerSecondaryClick = 2;

          # Change spaces with three fingers
          TrackpadThreeFingerHorizSwipeGesture = 2;

          # Show mission control by swiping up with three fingers
          TrackpadThreeFingerVertSwipeGesture = 2;
        };


      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };

  # If GPG complains about missing pinentry then try rebooting the machine.
  # There's likely some configuration error, too lazy to debug it now.
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  system.activationScripts.applications.text = pkgs.lib.mkForce (''
    rm -rf /Users/kuglimon/Applications/Nix\ Apps
    mkdir -p /Users/kuglimon/Applications/Nix\ Apps
    for app in ${config.system.build.applications}/Applications/*; do
      src="$(/usr/bin/stat -f%Y "$app")"
      cp -rL "$app" /Users/kuglimon/Applications/Nix\ Apps
    done
  '');


  # Activate system changes righ away rather than after login
  system.activationScripts.postUserActivation.text = ''
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
}
