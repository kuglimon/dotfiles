# WSL support
{
  lib,
  config,
  ...
}:
{
  options = {
    bundles.wsl = {
      enable = lib.mkEnableOption "Enables WSL support";
    };
  };

  config = lib.mkIf config.bundles.wsl.enable {

    system.stateVersion = "25.05";
    wsl.defaultUser = "kuglimon";
    wsl.enable = true;
  };
}
