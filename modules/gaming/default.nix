# le geims
{ lib, config, options, pkgs, ... }:

{
  options = {
    bundles.gaming = {
      enable = lib.mkEnableOption "Enables gaming, steam etc";
    };
  };

  config = lib.mkIf config.bundles.gaming.enable {
    # FIXME(tatu): Different systems have different users, this should be
    # configurable.
    users.users.kuglimon = {
      packages = with pkgs; [
        path-of-building
      ];
    };
  };
}
