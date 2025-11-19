# AMD CPU support
{
  lib,
  config,
  ...
}:
{
  options = {
    bundles.hardware.cpu.amd = {
      enable = lib.mkEnableOption "Enables AMD CPU support";
    };
  };

  config = lib.mkIf config.bundles.hardware.cpu.amd.enable {
    assertions = [
      {
        assertion = !config.bundles.hardware.cpu.intel.enable;
        message = "you have succesfully failed a task by enabling both amd and intel cpu support";
      }
    ];

    boot.kernelModules = [ "kvm-amd" ];

    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
