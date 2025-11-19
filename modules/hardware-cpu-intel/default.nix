# Intel CPU support
{
  lib,
  config,
  ...
}:
{
  options = {
    bundles.hardware.cpu.intel = {
      enable = lib.mkEnableOption "Enables Intel CPU support";
    };
  };

  config = lib.mkIf config.bundles.hardware.cpu.intel.enable {
    assertions = [
      {
        assertion = !config.bundles.hardware.cpu.amd.enable;
        message = "you have succesfully failed a task by enabling both amd and intel cpu support";
      }
    ];

    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
