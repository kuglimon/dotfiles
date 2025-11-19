{
  config,
  lib,
  modulesPath,
  ...
}:
{
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
}
