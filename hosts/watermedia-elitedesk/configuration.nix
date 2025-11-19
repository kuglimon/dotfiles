# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  pkgs,
  lib,
  ...
}:
{
  bundles.gui.enable = true;
  bundles.hardware.cpu.intel.enable = true;
  bundles.hardware.printers.enable = true;

  # All my development needs
  bundles.development.enable = true;
  bundles.terminal.enable = true;
  bundles.users.enable = true;

  # FIXME(tatu): Enable configurring in networking
  bundles.networking.hostname = "watermedia";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/3778a76d-048c-4b75-ba95-afe5b43faec2";
    fsType = "btrfs";
    options = [ "subvol=@root" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/3778a76d-048c-4b75-ba95-afe5b43faec2";
    fsType = "btrfs";
    options = [ "subvol=@nix-store" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/3778a76d-048c-4b75-ba95-afe5b43faec2";
    fsType = "btrfs";
    options = [ "subvol=@home" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/294C-AC49";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [ ];

  # Trying to run zfs on latest kernels is going to be a pain
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages;

  # XXX(tatu): this confusing as hell, this installs the kernel module.
  # Shouldn't I just list this above where kernel modules are defined?
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

  # ZFS needs this. Generated with 'head -c4 /dev/urandom | od -A none -t x4'.
  networking.hostId = "cf37e8cd";

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
  bundles.home-manager.stateVersion = "23.11";
}
