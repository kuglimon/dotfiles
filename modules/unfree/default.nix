# Inverse freedom module
#
# Previously I had to copy-paste the unfree packages to the host configurations.
# Meaning they were usually not close to the modules that configured the
# software. Using this enables all the modules to expose unfree packages.
#
# Since the unfree predicate is a function I couldn't come up with another way
# to do this. You can't merge functions in module configurations. I think.
{
  lib,
  config,
  ...
}:
{
  options = {
    bundles.unfreePackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };

  config = {
    nixpkgs.config.allowUnfreePredicate =
      pkg: builtins.elem (lib.getName pkg) config.bundles.unfreePackages;
  };
}
