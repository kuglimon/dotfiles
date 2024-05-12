let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-unstable";

  # FIXME(tatu): This whole package is fucked, it doesn't even build cosmocc,
  # it's just a regular gcc.
  # llamafileOverlays = self: super: {
  #   cosmopolitan = super.cosmopolitan.overrideAttrs {
  #     version = "3.3.6";
  #
  #     buildPhase = ''
  #       make toolchain
  #     '';
  #
  #     installPhase = ''
  #       ls -lah
  #       exit 1
  #     '';
  #   };
  # };

  pkgs = import nixpkgs { config = {}; overlays = [ ]; };
in rec
{
  cosmocc = pkgs.callPackage ./cosmocc.nix { };
  llamafile = pkgs.callPackage ./llamafile.nix { cosmocc = cosmocc; };
}
