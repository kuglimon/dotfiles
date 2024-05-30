{ config, lib, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/nvme1n1p1";
      fsType = "btrfs";
      options = [ "subvol=@nixos-root" "noatime" "ssd" "compress=zstd" ];
    };

  fileSystems."/home" =
    { device = "/dev/nvme1n1p1";
      fsType = "btrfs";
      options = [ "subvol=@home" "noatime" "ssd" "compress=zstd" ];
    };

  fileSystems."/home/kuglimon/.local/share/Steam" =
    { device = "/dev/nvme1n1p1";
      fsType = "btrfs";
      options = [ "subvol=@steam" "noatime" "ssd" "compress=zstd" ];
    };

  fileSystems."/nix" =
    { device = "/dev/nvme1n1p1";
      fsType = "btrfs";
      options = [ "subvol=@nix-store" "noatime" "ssd" "compress=zstd" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/A836-5A29";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # I'm not sure why I even need to enable stuff like this.
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;

    # I don't have free enery to spend on 100w idle GPU. This can cause issues
    # with sleep/hibernate but who the fuck uses that on linux, plain boot is
    # plenty fast.
    powerManagement.enable = true;
    # TODO(tatu): Doesn't work, complains about off-load
    # powerManagement.finegrained = true;

    # NVidia open source kernel module is not stable, don't use it, yet.
    open = false;

    # Enables 'nvidia-settings' command/app.
    nvidiaSettings = true;

    # Install nvidia production drivers. I don't even know why I use production
    # drivers, it seems like they're the latest.
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };
}
