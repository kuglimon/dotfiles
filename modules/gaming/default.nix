# le geims
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
    assertions = [
      {
        assertion = config.bundles.gui.enable;
        message = "you probably want to enable gui for gaming";
      }
    ];

    # FIXME(tatu): Different systems have different users, this should be
    # configurable.
    users.users.kuglimon = {
      packages = with pkgs; [
        mangohud
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

    bundles.unfreePackages = [
      "steam"
      "steam-unwrapped"
      "starsector"
    ];
  };
}
