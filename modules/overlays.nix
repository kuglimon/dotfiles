{ inputs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      aisabox = final.callPackage ../pkgs/aisabox { };

      vimPlugins = prev.vimPlugins.extend (
        _vfinal: _vprev: {
          presenterm-nvim = final.callPackage ../pkgs/presenterm-nvim { };
        }
      );

      # See the nixos-shell input in flake.nix
      nixos-shell = inputs.nixos-shell.packages.${final.stdenv.hostPlatform.system}.nixos-shell;
    })
  ];
}
