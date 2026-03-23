{ ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      aisabox = final.callPackage ../pkgs/aisabox { };
    })
  ];
}
