# Dependencies: keepassxc and nixos-shell must be in PATH.
# If you install them via systemPackages / home.packages alongside
# this script, writeShellApplication's runtimeInputs handles the rest.
#
{ pkgs }:

pkgs.writeShellApplication {
  name = "aisabox";

  runtimeInputs = with pkgs; [
    keepassxc
    coreutils
    nixos-shell
  ];

  text = ''
    usage() {
      cat <<EOF
    Usage: claude-vm [OPTIONS] [PROJECT_DIR]

    Launch a sandboxed Claude Code VM for a project.

    Arguments:
      PROJECT_DIR           Path to the project (default: current directory)

    Options:
      -c, --config PATH     Path to vm.nix (default: PROJECT_DIR/vm.nix)
      -h, --help            Show this help

    Examples:
      claude-vm                          # cwd with vm.nix
      claude-vm ~/projects/my-app        # ~/projects/my-app/vm.nix
      claude-vm -c ~/vms/rust.nix .      # shared vm.nix for cwd
    EOF
      exit 0
    }

    PROJECT_DIR=""
    VM_CONFIG=""

    while [[ $# -gt 0 ]]; do
      case "$1" in
        -c|--config) VM_CONFIG="$(realpath "$2")"; shift 2 ;;
        -h|--help)   usage ;;
        -*)          echo "Unknown option: $1" >&2; exit 1 ;;
        *)           PROJECT_DIR="$1"; shift ;;
      esac
    done

    PROJECT_DIR="$(realpath "''${PROJECT_DIR:-.}")"

    if [ ! -d "$PROJECT_DIR" ]; then
      echo "Error: $PROJECT_DIR is not a directory" >&2
      exit 1
    fi

    if [ -z "$VM_CONFIG" ] && [ -f "$PROJECT_DIR/vm.nix" ]; then
      VM_CONFIG="$PROJECT_DIR/vm.nix"
    fi

    if [ ! -d "$PROJECT_DIR/.git" ]; then
      echo "Warning: $PROJECT_DIR is not a git repository." >&2
      echo "The .git read-only protection will be inactive." >&2
      read -rp "Continue anyway? [y/N] " confirm
      [[ "$confirm" =~ ^[Yy]$ ]] || exit 0
    fi

    # ── Ephemeral secrets in RAM ────────────────────────────────
    SECRET_DIR="$(mktemp -d --tmpdir=/dev/shm)"
    cleanup() { rm -rf "$SECRET_DIR"; }
    trap cleanup EXIT

    if [ ! -d "$HOME/.claude" ]; then
      echo "Claude authentication directory doesn't exist" >&2
      exit 1
    fi

    # ── Optional project import ────────────────────────────────
    PROJECT_IMPORT_LINE=""
    if [ -n "$VM_CONFIG" ]; then
      PROJECT_IMPORT_LINE="$VM_CONFIG"
      echo "Using project config: $VM_CONFIG" >&2
    fi

    # ── Generate wrapper vm.nix ─────────────────────────────────
    cat > "$SECRET_DIR/vm.nix" <<NIXEOF
    { pkgs, ... }: {
      imports = [
        ${./module.nix}
        $PROJECT_IMPORT_LINE
      ];

      nixos-shell.mounts.extraMounts = {
        "/project" = {
          target = "$PROJECT_DIR";
          cache = "none";
        };
        "/home/$USER/.claude" = {
          target = "$HOME/.claude";
          cache = "none";
        };
      };
    }
    NIXEOF

    echo "Starting Claude VM for: $PROJECT_DIR" >&2
    cd "$SECRET_DIR"
    nixos-shell vm.nix
  '';
}
