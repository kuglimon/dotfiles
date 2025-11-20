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
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      modules = pkgs.lib.filesystem.listFilesRecursive ./modules;
    in
    {
      packages.${system} = {
        release-wsl-tarbal = pkgs.callPackage ./pkgs/release-wsl-tarbal.nix {
          tarballBuilder = self.nixosConfigurations.wsl.config.system.build.tarballBuilder;
        };
      };

      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit self;
          inherit inputs;
        };
        modules = [
          home-manager.nixosModules.home-manager
          ./hosts/kuglimon-desktop/configuration.nix
        ]
        ++ modules;
      };

      nixosConfigurations.watermedia = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit self;
          inherit inputs;
        };
        modules = [
          home-manager.nixosModules.home-manager
          ./hosts/watermedia-elitedesk/configuration.nix
        ]
        ++ modules;
      };

      nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
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
        ]
        ++ modules;
      };

      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = [
          pkgs.gh
          self.packages.${system}.release-wsl-tarbal

          # FIXME(tatu): Calling binaries from package works locally using 'nix
          # develop --command' but fails in Github CI. I haven't had the time to
          # debug why.
          self.nixosConfigurations.wsl.config.system.build.tarballBuilder
        ];
      };
    };
}
