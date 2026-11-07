# Neovim integration for presenterm, not packaged in nixpkgs.
#
# The plugin shells out to the presenterm binary for previews, so presenterm
# must be in PATH.
{
  vimUtils,
  fetchFromGitHub,
}:

vimUtils.buildVimPlugin rec {
  pname = "presenterm-nvim";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "Piotr1215";
    repo = "presenterm.nvim";
    rev = "v${version}";
    hash = "sha256-gNmgb2v0HBXQqvWRLu22hILy7Gl1B3nz9chiFbUG/Wc=";
  };
}
