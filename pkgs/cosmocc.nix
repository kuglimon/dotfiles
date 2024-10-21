{
  stdenv,
  fetchzip,
}:
stdenv.mkDerivation rec {
  pname = "cosmocc";
  version = "3.3.6";

  # Stripping cosmopolitan binaries breaks them. It'll detect them as windows
  # binaries after stripping.
  dontStrip = true;

  # There's nothing to build
  dontBuild = true;

  src = fetchzip {
    url = "https://github.com/jart/cosmopolitan/releases/download/${version}/cosmocc-${version}.zip";
    stripRoot = false;
    sha256 = "sha256-Fx1nZzWjTNCtRE7/xs6tfPotVtMb4VTEXkwOg+/865o=";
  };

  installPhase = ''
    mkdir -p $out

    # TODO(tatu): I think a proper way would be to have outputs for each of
    # these?
    # FIXME(tatu): all other files but the licenses are required
    mv * $out
  '';
}
