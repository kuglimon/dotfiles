{ ... }:
{
  nixpkgs.overlays = [
    (final: _prev: {
      aisabox = final.callPackage ../pkgs/aisabox { };
    })
  ];
}
