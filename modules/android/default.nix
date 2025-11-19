# Android related stuff
{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    bundles.android = {
      enable = lib.mkEnableOption "Enable android related stuff";
    };
  };

  config = lib.mkIf config.bundles.android.enable {
    environment.systemPackages = with pkgs; [
      # For mounting Android MTP drives
      jmtpfs
    ];
  };
}
