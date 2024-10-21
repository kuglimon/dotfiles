{
  stdenv,
  fetchFromGitHub,
  gnumake,
  unzip,
  cosmocc,
}:
stdenv.mkDerivation rec {
  pname = "llamafile";
  version = "0.8.4";

  # Stripping cosmopolitan binaries breaks them. It'll detect them as windows
  # binaries after stripping.
  dontStrip = true;

  src = fetchFromGitHub {
    owner = "Mozilla-Ocho";
    repo = "llamafile";
    rev = version;
    hash = "sha256-j7iPq1H3eB++aEMp2lbhMSO90t3DLFqgDQ4dseS9v7E=";
  };

  makeFlags = ["PREFIX=${placeholder "out"}" "COSMOCC=${cosmocc}"];

  buildInputs = [
    unzip
    cosmocc
    gnumake
  ];
}
