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

  bundles.gui.enable = true;
  bundles.hardware.gpu.nvidia.enable = true;
  bundles.hardware.cpu.amd.enable = true;

  bundles.hardware.printers.enable = true;

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
