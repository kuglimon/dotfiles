{
  writeShellApplication,
  tarballBuilder,
  gh,
}:
let
  # Can't be arsed to write a HEREDOC in the script :D
  release_message = ''
    # Rolling releases from my dotfiles

    Use at your own peril. These update on each commit and there's no
    versioning.

    Some release artifacts might be split into pieces due to Github Release size
    limitations.

    ## Artifacts
    **nixos.wsl-partxx** - WSL image of my development environment

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
      echo "Error! GitHub CLI is not authenticated: Run 'gh auth login'"
      exit 1
    fi

    # Make sure we're not over the 2gb limit
    echo "Splitting release to fit Github limits"
    split -d -b 2047483648 nixos.wsl "$ASSET_PATH-part"

    RELEASE_MESSAGE+='## Downloading'$'\n'
    RELEASE_MESSAGE+=$'\n'
    RELEASE_MESSAGE+='```bash'$'\n'
    for part in "$ASSET_PATH-part"*; do
      RELEASE_MESSAGE+="curl -L https://github.com/kuglimon/dotfiles/releases/download/latest/$part"$'\n'
    done
    RELEASE_MESSAGE+="cat $ASSET_PATH* > nixos.wsl"$'\n'
    RELEASE_MESSAGE+='```'$'\n'

    release_assets=$(gh release view "$TAG_NAME" --repo "$REPO" --json assets --jq '.assets[].name') 2>/dev/null

    if [ ! -z "$release_assets" ]; then
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

    while IFS= read -r old_asset; do
      gh release delete-asset "$TAG_NAME" "$old_asset" \
        --repo "$REPO" --yes || true
    done <<< "$release_assets"

    # Upload asset (if exists)
    if [ -f "$ASSET_PATH" ]; then
      gh release upload "$TAG_NAME" "$ASSET_PATH-part"* \
        --repo "$REPO" --clobber
    fi

    echo "Rolling release updated"
  '';
}
