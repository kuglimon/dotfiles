{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/nvme1n1p1";
    fsType = "btrfs";
    options = ["subvol=@nixos-root" "noatime" "ssd" "compress=zstd"];
  };

  fileSystems."/home" = {
    device = "/dev/nvme1n1p1";
    fsType = "btrfs";
    options = ["subvol=@home" "noatime" "ssd" "compress=zstd"];
  };

  fileSystems."/home/kuglimon/.local/share/Steam" = {
    device = "/dev/nvme1n1p1";
    fsType = "btrfs";
    options = ["subvol=@steam" "noatime" "ssd" "compress=zstd"];
  };

  fileSystems."/nix" = {
    device = "/dev/nvme1n1p1";
    fsType = "btrfs";
    options = ["subvol=@nix-store" "noatime" "ssd" "compress=zstd"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/A836-5A29";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Enables hardware rendering. This used to be called 'hardware.opengl' which
  # was SUPER confusing.
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;

    # I don't have free energy to spend on 100w idle GPU. This can cause issues
    # with sleep/hibernate but who the fuck uses that on linux, plain boot is
    # plenty fast.
    powerManagement.enable = true;
    # TODO(tatu): Doesn't work, complains about off-load
    # powerManagement.finegrained = true;

    # Open Source modules don't support G-Sync, enable once support lands.
    open = false;

    # Enables 'nvidia-settings' command/app.
    nvidiaSettings = true;

    # FIXME(tatu): Swapped to beta drivers as stable ones are broken on 6.12
    # stable is the 'feature' version listed on nvidia site. This is the one
    # Arch Linux installs, hence we'll use this as well.
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
}
