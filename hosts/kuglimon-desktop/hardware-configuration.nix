{
  config,
  lib,
  modulesPath,
  ...
}:
{

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];

  boot.initrd.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/nvme0n1p1";
    fsType = "btrfs";
    options = [
      "subvol=@nixos-root"
      "noatime"
      "ssd"
      "compress=zstd"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/nvme0n1p1";
    fsType = "btrfs";
    options = [
      "subvol=@home"
      "noatime"
      "ssd"
      "compress=zstd"
    ];
  };

  fileSystems."/home/kuglimon/.local/share/Steam" = {
    device = "/dev/nvme0n1p1";
    fsType = "btrfs";
    options = [
      "subvol=@steam"
      "noatime"
      "ssd"
      "compress=zstd"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/nvme0n1p1";
    fsType = "btrfs";
    options = [
      "subvol=@nix-store"
      "noatime"
      "ssd"
      "compress=zstd"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/A836-5A29";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted
  # networking (the default) this is the recommended approach. When using
  # systemd-networkd it's still possible to use this option, but it's
  # recommended to use it in conjunction with explicit per-interface
  # declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
