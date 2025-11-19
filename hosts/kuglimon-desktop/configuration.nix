{
  ...
}:
{
  bundles.gui.enable = true;
  bundles.hardware.gpu.nvidia.enable = true;
  bundles.hardware.cpu.amd.enable = true;

  bundles.hardware.printers.enable = true;

  # Includes steam, path of building, and all the other jazz
  bundles.gaming.enable = true;

  # All my development needs
  bundles.development.enable = true;
  bundles.terminal.enable = true;
  bundles.virtualization.enable = true;
  bundles.android.enable = true;
  bundles.users.enable = true;

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
