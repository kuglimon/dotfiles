{
  inputs,
  pkgs,
  ...
}:
{
  # TODO(tatu): maybe is should just drop home-manager completely. I use it for
  # like firefox profiles and that's it. There's probably another way to install
  # dotfiles without it.
  imports = with inputs; [
    ./hardware-configuration.nix
  ];

  # home-manager options
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.kuglimon =
    { ... }:
    {
      imports = [
        # ../../modules/home-manager/common
        ./home.nix
      ];
    };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  bundles.gui.enable = true;

  bundles.unfreePackages = [
    # nvidia drivers
    "nvidia-settings"
    "nvidia-x11"

    "samsung-unified-linux-driver"
  ];

  # These are based on Arch Linux defaults:
  #   https://gitlab.archlinux.org/archlinux/packaging/packages/filesystem/-/blob/main/sysctl
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 524288;
    "fs.inotify.max_user_instances" = 1024;

    # Games are known to exhaust this:
    #   https://lists.archlinux.org/archives/list/arch-dev-public@lists.archlinux.org/thread/5GU7ZUFI25T2IRXIQ62YYERQKIPE3U6E/
    "vm.max_map_count" = 1048576;
  };

  boot.loader.timeout = 0;

  # Configure Arch Linux dualboot with NixOS.
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  networking.hostName = "desktop"; # Define your hostname.
  networking.nameservers = [
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

  # Includes steam, path of building, and all the other jazz
  bundles.gaming.enable = true;

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
      btrfs-progs

      # Enable back once tests don't fail and the damn app doesn't register it
      # as default app for everything.
      # calibre
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

  environment.systemPackages = with pkgs; [
    # For mounting Android MTP drives
    jmtpfs
  ];

  # Make mah printer work
  services.printing = {
    enable = true;
    drivers = [ pkgs.samsung-unified-linux-driver_4_01_17 ];
  };

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true;
  programs.virt-manager.enable = true;

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
