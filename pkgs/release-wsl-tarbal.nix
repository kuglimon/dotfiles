{
  writeShellApplication,
  tarballBuilder,
  gh
}:
let
  # Can't be arsed to write a HEREDOC in the script :D
  release_message = ''
    # Rolling releases from my dotfiles

    Use at your own peril. These update on each commit and there's no
    versioning.

    ## Artifacts
    **nixos.wsl** - WSL image of my development environment for sadness
  '';
in
writeShellApplication {
  name = "gh-release-wsl-tarbal";

  runtimeInputs = [ gh ];

  # FIXME(tatu): Haven't really gone through this with thought, AI generated
  # crap. Maybe works, maybe not.
  text = ''
    REPO="kuglimon/dotfiles"
    TAG_NAME="latest"
    RELEASE_NAME="Rolling Release"
    ASSET_PATH="nixos.wsl"

    RELEASE_MESSAGE="${release_message}"

    # Not sure why this needs to be sudo per WSL NixOS docs? To copy from
    # /nix/store?
    sudo ${tarballBuilder}/bin/nixos-wsl-tarball-builder

    if [ ! -f "$ASSET_PATH" ]; then
      echo "$ASSET_PATH missing! You forgot to generate tarbal, GG!"
      exit 1
    fi

    if ! gh auth status &>/dev/null; then
        echo "Error: GitHub CLI is not authenticated. Run 'gh auth login'."
        exit 1
    fi

    if gh release view "$TAG_NAME" --repo "$REPO" 2>/dev/null; then
        echo "Updating existing rolling release..."
        gh release edit "$TAG_NAME" \
            --repo "$REPO" \
            --notes "$RELEASE_MESSAGE" \
            --latest
    else
        echo "Creating new rolling release..."
        gh release create "$TAG_NAME" \
            --repo "$REPO" \
            --title "$RELEASE_NAME" \
            --notes "$RELEASE_MESSAGE" \
            --latest \
            --target master
    fi

    # Upload asset (if exists)
    if [ -f "$ASSET_PATH" ]; then
        echo "Uploading asset..."
        ASSET_NAME=$(basename "$ASSET_PATH")
        gh release delete-asset "$TAG_NAME" "$ASSET_NAME" \
          --repo "$REPO" --yes || true
        gh release upload "$TAG_NAME" "$ASSET_PATH" \
          --repo "$REPO" --clobber
        echo "Asset uploaded."
    fi

    echo "Rolling release updated."
  '';
}
