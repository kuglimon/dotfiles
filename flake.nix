{
  description = "My machine configurations";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
    };

    new-pob = {
      url = "github:K900/nixpkgs/8c1bc204d98b4e9edece53886b3a9897b17c40d2";
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

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    nixos-wsl,
    ...
  }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system} = rec {
      cosmocc = pkgs.callPackage ./pkgs/cosmocc.nix {};
      llamafile = pkgs.callPackage ./pkgs/llamafile.nix {cosmocc = cosmocc;};
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
        ./modules/development
        ./modules/gaming
        ./machines/kuglimon-desktop/configuration.nix
      ];
    };

    nixosConfigurations.watermedia = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit self;
        inherit inputs;
      };
      modules = [
        ./machines/watermedia-elitedesk/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.kuglimon = {...}: {
            imports = [./machines/watermedia-elitedesk/home.nix];
          };
        }
      ];
    };

    nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit self;
        inherit inputs;
      };
      modules = [
        nixos-wsl.nixosModules.default
        {
          system.stateVersion = "25.05";
          wsl.defaultUser = "kuglimon";
          wsl.enable = true;
        }
        ./modules/development
        ./machines/kuglimon-wsl/configuration.nix
      ];
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
