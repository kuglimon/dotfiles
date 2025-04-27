# le geims
#
# XXX(tatu): Check host specific configuration for allowUnfreePredicate. Stuff
# like steam is still defined there which is kind of ass.
{
  lib,
  config,
  options,
  pkgs,
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
        path-of-building

        # GOTY of all the years
        (starsector.overrideAttrs (oldAttrs: {
          version = "0.98a-RC8";

          src = fetchzip {
            url = "https://f005.backblazeb2.com/file/fractalsoftworks/release/starsector_linux-0.98a-RC8.zip";
            sha256 = "sha256-W/6QpgKbUJC+jWOlAOEEGStee5KJuLi020kRtPQXK3U=";
          };
        }))
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
