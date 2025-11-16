# le geims
#
# XXX(tatu): Check host specific configuration for allowUnfreePredicate. Stuff
# like steam is still defined there which is kind of ass.
{
  lib,
  config,
  pkgs,
  self,
  ...
}:
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
        mangohud
        # rusty-path-of-building
        rusty-path-of-building

        # GOTY of all the years
        starsector
      ];
    };

    programs.gamescope = {
      enable = true;
      capSysNice = false;
    };

    programs.steam = {
      enable = true;
    };
  };
}
