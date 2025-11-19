# Configures a user and maybe some random extras
{
  lib,
  config,
  ...
}:
{
  options = {
    bundles.users = {
      enable = lib.mkEnableOption "Setups the default user";
    };
  };

  config = lib.mkIf config.bundles.users.enable {

    # FIXME(tatu): Enable customizing user
    users.users.kuglimon = {
      isNormalUser = true;
      createHome = true;

      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
      ];
    };

    users.users.kuglimon.initialPassword = "replaceme";

    # Set your time zone.
    time.timeZone = "Europe/Helsinki";
  };
}
