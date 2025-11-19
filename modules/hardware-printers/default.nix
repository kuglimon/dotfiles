# Enable my printers
{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    bundles.hardware.printers = {
      enable = lib.mkEnableOption "Enables Printer support";
    };
  };

  config = lib.mkIf config.bundles.hardware.printers.enable {

    # FIXME(tatu): Get model with lpinfo -m and automatically add my printer.
    # Too lazy to fix now.
    #
    # hardware.printers = {
    #   ensurePrinters = [
    #     {
    #       name = "Samsung_M2070_Series";
    #       location = "Home";
    #       deviceUri = "usb://Samsung/M2070%20Series?serial=ZF5RB8KH3B010TN&interface=1";
    #       model = "drv:///sample.drv/generic.ppd";
    #       ppdOptions = {
    #         PageSize = "A4";
    #       };
    #     }
    #   ];
    #   ensureDefaultPrinter = "Samsung_M2070_Series";
    # };

    # Make mah printer work
    services.printing = {
      enable = true;
      drivers = [ pkgs.samsung-unified-linux-driver_4_01_17 ];
    };

    bundles.unfreePackages = [
      "samsung-unified-linux-driver"
    ];
  };
}
