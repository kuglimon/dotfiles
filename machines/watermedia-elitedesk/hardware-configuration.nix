{ lib, config, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/3778a76d-048c-4b75-ba95-afe5b43faec2";
      fsType = "btrfs";
      options = [ "subvol=@root" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/3778a76d-048c-4b75-ba95-afe5b43faec2";
      fsType = "btrfs";
      options = [ "subvol=@nix-store" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/3778a76d-048c-4b75-ba95-afe5b43faec2";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/294C-AC49";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [];

  # XXX(tatu): this confusing as hell, this installs the kernel module.
  # Shouldn't I just list this above where kernel modules are defined?
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

  # ZFS needs this. Generated with 'head -c4 /dev/urandom | od -A none -t x4'.
  networking.hostId = "cf37e8cd";

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
