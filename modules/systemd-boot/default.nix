# Configures systemd-boot
{
  lib,
  config,
  ...
}:
{
  options = {
    bundles.systemd-boot = {
      enable = lib.mkEnableOption "Enables systemd-boot support";
    };
  };

  config = lib.mkIf config.bundles.systemd-boot.enable {
    boot.loader.timeout = 0;

    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.configurationLimit = 10;
  };
}
