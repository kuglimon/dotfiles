# Various Kernel tweaks
{
  lib,
  pkgs,
  ...
}:
{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # These are based on Arch Linux defaults:
  #   https://gitlab.archlinux.org/archlinux/packaging/packages/filesystem/-/blob/main/sysctl
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 524288;
    "fs.inotify.max_user_instances" = 1024;

    # Games are known to exhaust this:
    #   https://lists.archlinux.org/archives/list/arch-dev-public@lists.archlinux.org/thread/5GU7ZUFI25T2IRXIQ62YYERQKIPE3U6E/
    "vm.max_map_count" = 1048576;
  };

  # Following stolen from:
  #   https://github.com/hlissner/dotfiles/blob/b51c0d90673a3f3779197ca53952bfe85718f708/modules/security.nix
  #
  ## System security tweaks
  # tmpfs = /tmp is mounted in ram. Doing so makes temp file management speedy
  # on ssd systems and more secure (and volatile!) because it's wiped on reboot.
  boot.tmp.useTmpfs = lib.mkDefault true;

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
}
