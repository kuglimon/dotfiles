{ self, inputs, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Switch to latest from the default LTS kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "discord"
      "spotify"

      # FIXME(tatu): These should be set on the gaming modules but it doesn't
      # work. If I move these it'll start complaining about the samsung drivers.
      # Which leads me to believe the module configuration overrides this
      # completely rather than merging.
      "steam"
      "steam-original"
      "steam-run"

      # nvidia drivers
      "libXNVCtrl"
      "nvidia-settings"
      "nvidia-x11"

      # cuda crap
      "cuda_nvcc"
      "cuda_cudart"
      "cuda-merged"
      "cuda_cuobjdump"
      "cuda_gdb"
      "cuda_nvdisasm"
      "cuda_nvprune"
      "cuda_cccl"
      "cuda_cupti"
      "cuda_cuxxfilt"
      "cuda_nvml_dev"
      "cuda_nvrtc"
      "cuda_nvtx"
      "cuda_profiler_api"
      "cuda_sanitizer_api"
      "libcublas"
      "libcufft"
      "libcurand"
      "libcusolver"
      "libnvjitlink"
      "libcusparse"
      "libnpp"

      # For samsung printers
      "samsung-UnifiedLinuxDriver"
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
    "fs.inotify.max_user_watches"   = 524288;
    "fs.inotify.max_user_instances" = 1024;

    # Games are known to exhaust this:
    #   https://lists.archlinux.org/archives/list/arch-dev-public@lists.archlinux.org/thread/5GU7ZUFI25T2IRXIQ62YYERQKIPE3U6E/
    "vm.max_map_count"  = 1048576;
  };

  boot.loader.timeout = 0;

  # Configure Arch Linux dualboot with NixOS.
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  networking.hostName = "desktop"; # Define your hostname.
  networking.nameservers = [
    "9.9.9.9" # quad9
    "1.1.1.1" # cloudflare
  ];

  networking.dhcpcd = {
    enable = true;

    # TODO(tatu): I should really configure a static IP or do something about
    # this. DHCP takes like 10 seconds on NixOS. This should make it so that it
    # doesn't wait for IP.
    wait = "background";

    extraConfig = ''
    noarp
    '';
  };

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

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
    (nerdfonts.override { fonts = ["FiraMono"]; })
  ];

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    autorun = false;

    # TODO(tatu): Should move this, hardware dependent
    videoDrivers = ["nvidia"];

    windowManager.i3 = {
      enable = true;
    };

    displayManager = {
      # Login to vtty. I don't want a graphical user login, it's just useless
      # crap. When there's an issue with the system it's almost always due to
      # the GUI. It's super rare in linux nowadays, but why would I waste my
      # life on a solution that opens the path to failure when I can have a path
      # where it cannot ever exist?
      startx.enable = true;

    };

    xkb = {
      # Enable Finnish layout
      layout = "fi";

      # Map capslock to escape
      options = "caps:escape";
    };

    # I'm still unsure if I should just use the nix options or my old
    # configuration files.
    extraConfig = builtins.readFile ../../dotfiles/X11/50-mouse-acceleration.conf;

    excludePackages = with pkgs; [
      xterm
    ];
  };

  services.displayManager = {
    defaultSession = "none+i3";
  };

  # Includes steam, path of building, and all the other jazz
  bundles.gaming.enable = true;

  # Still need to set password with 'passwd' after creation.
  users.users.kuglimon = {
    isNormalUser = true;
    extraGroups = [
      "wheel"     # Enable ‘sudo’ for the user.
      "libvirtd"  # Enables virt-manager to connect to kvm?
    ];

    createHome = true;
    packages = with pkgs; [
      alacritty
      alacritty-theme

      # the 'bash' package is a minimal bash installation meant for scripts and
      # automation. We want the full package for interactive use.
      bashInteractive
      bat
      btrfs-progs
      calibre
      cargo
      discord
      docker
      docker-buildx
      dosfstools
      dunst
      feh
      flameshot
      fuse3
      fzf
      gcc
      ghostscript
      git
      git-crypt
      git-lfs
      go
      imagemagick
      jq
      keepassxc
      killall
      newsboat
      nodejs
      nodejs_latest
      (polybar.override { i3Support = true; })
      pulsemixer
      qemu
      rclone
      ripgrep
      rofi
      rust-analyzer
      rustc
      rustfmt
      spotify
      tmux
      tree
      unzip
      xclip
      zsh
      zsh-completions

      cudaPackages.cuda_nvcc
      cudaPackages.cuda_cudart
      cudaPackages.cudatoolkit

      # Not sure if there's a cleaner way to reference packages from custom
      # repositories.
      inputs.rojekti.packages.${system}.default
      self.packages.${pkgs.system}.llamafile
    ];
  };

  environment.systemPackages = with pkgs; [
    neovim

    # For mounting Android MTP drives
    jmtpfs
  ];

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

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

  # If GPG complains about missing pinentry then try rebooting the machine.
  # There's likely some configuration error, too lazy to debug it now.
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
    enableSSHSupport = true;
  };

  programs.git.lfs.enable = true;

  # Make mah printer work
  services.printing = {
    enable = true;
    drivers = [ pkgs.samsung-unified-linux-driver_4_01_17 ];
  };

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true;
  programs.virt-manager.enable = true;

  # Get model with lpinfo -m and automatically add my printer. Too lazy to fix
  # now.
  # hardware.printers = {
  #   ensurePrinters = [
  #     {
  #       name = "Samsung_M2070_Series";
  #       location = "Home";
  #       deviceUri = "usb://Samsung/M2070%20Series?serial=ZF5RB8KH3B010TN&interface=1";
  #       model = "drv:///sample.drv/generic.ppd";
  #       ppdOptions = {
  #         PageSize = "A4";
  #       };
  #     }
  #   ];
  #   ensureDefaultPrinter = "Samsung_M2070_Series";
  # };

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
  system.stateVersion = "23.11"; # Did you read the comment?
}

