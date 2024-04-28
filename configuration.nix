# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
    ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Configure Arch Linux dualboot with NixOS.
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.extraEntries = ''
    menuentry 'Arch Linux' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-58c19a90-bbdc-4f28-9224-0521322e7739' {
      # load_video
      set gfxpayload=keep
      insmod gzio
      insmod part_gpt
      insmod fat
      search --no-floppy --fs-uuid --set=root A836-5A29
      echo	'Loading Linux linux ...'
      linux	/vmlinuz-linux root=UUID=58c19a90-bbdc-4f28-9224-0521322e7739 rw rootflags=subvol=@arch  loglevel=3 quiet
      echo	'Loading initial ramdisk ...'
      initrd	/initramfs-linux.img
    }
  '';

  console.keyMap = "fi";

  networking.hostName = "desktop"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

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
  };

  services.displayManager = {
    defaultSession = "none+i3";
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Still need to set password with 'passwd' after creation.
  users.users.kuglimon = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    createHome = true;
    packages = with pkgs; [
      bash
      bat
      btrfs-progs
      cargo
      docker
      docker-buildx
      dosfstools
      dunst
      feh
      fuse3
      fzf
      gcc
      ghostscript
      git
      git-crypt
      go
      imagemagick
      jq
      neovim
      newsboat
      nodejs
      nodejs_latest
      pulsemixer
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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
  ];

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

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

