{
  description = "My machine configurations";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Helper for managing tmux layouts. It's a monorepo and this allows me to
    # pull just one project from a subdirectory.
    rojekti = {
      url = "github:UncertainSchrodinger/molokki";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nixos-wsl,
      git-hooks,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      modules = pkgs.lib.filesystem.listFilesRecursive ./modules;

      pre-commit-check = git-hooks.lib.${system}.run {
        src = ./.;
        # Use prek instead of pre-commit
        package = pkgs.prek;
        hooks = {
          # Nix hygiene
          nixfmt-rfc-style.enable = true;
          deadnix.enable = true;

          # Commit message format check
          commit-format = {
            enable = true;
            name = "commit message format";
            description = "enforce '<component>: <description>' with lowercase description";
            stages = [ "commit-msg" ];
            entry = "${pkgs.writeShellScript "check-commit-format" ''
              set -eu
              msg_file="$1"

              # Read first line, skip comment lines and empty lines
              first_line=$(grep -v '^#' "$msg_file" | grep -v '^$' | head -n1 || true)

              # Allow merge/revert/fixup commits to pass
              case "$first_line" in
                "Merge "*|"Revert "*|"fixup! "*|"squash! "*) exit 0 ;;
              esac

              # Match: lowercase-component-with-optional-dashes-or-slashes: lowercase-start
              if ! echo "$first_line" | grep -qE '^[a-z][a-z0-9._/-]*: [a-z]'; then
                echo "✗ commit message must match: '<component>: <description>'" >&2
                echo "  - component: lowercase letters, digits, dots, slashes, underscores, dashes" >&2
                echo "  - description: must start with a lowercase letter" >&2
                echo "" >&2
                echo "  got: $first_line" >&2
                echo "" >&2
                echo "  retry with: git commit -e -F .git/COMMIT_EDITMSG" >&2
                exit 1
              fi
            ''}";
          };
        };
      };
    in
    {
      checks.${system}.pre-commit-check = pre-commit-check;

      packages.${system} = {
        release-wsl-tarbal = pkgs.callPackage ./pkgs/release-wsl-tarbal.nix {
          tarballBuilder = self.nixosConfigurations.wsl.config.system.build.tarballBuilder;
        };
      };

      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit self;
          inherit inputs;
        };
        modules = [
          home-manager.nixosModules.home-manager
          ./hosts/kuglimon-desktop/configuration.nix
          { nixpkgs.hostPlatform = "x86_64-linux"; }
        ]
        ++ modules;
      };

      nixosConfigurations.watermedia = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit self;
          inherit inputs;
        };
        modules = [
          home-manager.nixosModules.home-manager
          ./hosts/watermedia-elitedesk/configuration.nix
          { nixpkgs.hostPlatform = "x86_64-linux"; }
        ]
        ++ modules;
      };

      nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit self;
          inherit inputs;
        };
        modules = [
          home-manager.nixosModules.home-manager
          nixos-wsl.nixosModules.default
          # I don't want to have the WSL as a common module as I'd have to
          # import it across all configurations.
          {
            wsl.defaultUser = "kuglimon";
            wsl.enable = true;
          }
          ./hosts/kuglimon-wsl/configuration.nix
          { nixpkgs.hostPlatform = "x86_64-linux"; }
        ]
        ++ modules;
      };

      devShells.${system}.default = pkgs.mkShell {
        inherit (pre-commit-check) shellHook;
        buildInputs = [
          pkgs.gh
          self.packages.${system}.release-wsl-tarbal

          # FIXME(tatu): Calling binaries from package works locally using 'nix
          # develop --command' but fails in Github CI. I haven't had the time to
          # debug why.
          self.nixosConfigurations.wsl.config.system.build.tarballBuilder
        ]
        ++ pre-commit-check.enabledPackages;
      };
    };
}
