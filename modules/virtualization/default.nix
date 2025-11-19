# Configures my virtualization
{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    bundles.virtualization = {
      enable = lib.mkEnableOption "Enables virtualization";
    };
  };

  config = lib.mkIf config.bundles.virtualization.enable {
    # Still need to set password with 'passwd' after creation.
    users.users.kuglimon = {
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
        "libvirtd" # Enables virt-manager to connect to kvm?
        "docker"
      ];
    };

    virtualisation.docker.enable = true;
    virtualisation.libvirtd.enable = true;
    virtualisation.libvirtd.qemu.swtpm.enable = true;
    programs.virt-manager.enable = true;
  };
}
