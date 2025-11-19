# Basic home manager configuration
{
  lib,
  config,
  ...
}:
{
  options = {
    bundles.home-manager.stateVersion = lib.mkOption {
      type = lib.types.str;
      description = "Original home manger state version";
    };
  };

  config = {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    home-manager.users.kuglimon =
      { ... }:
      {
        home.username = "kuglimon";
        home.homeDirectory = "/home/kuglimon";
        home.stateVersion = config.bundles.home-manager.stateVersion;
        programs.home-manager.enable = true;
      };
  };
}
