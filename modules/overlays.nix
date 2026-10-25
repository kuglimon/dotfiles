{ inputs, ... }:
{
  nixpkgs.overlays = [
    (final: _prev: {
      aisabox = final.callPackage ../pkgs/aisabox { };

      # See the nixos-shell input in flake.nix
      nixos-shell = inputs.nixos-shell.packages.${final.stdenv.hostPlatform.system}.nixos-shell;
    })
  ];
}
