{
  description = "My machine configurations";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # The whole mac ecosystem is tied to homebrew. It's just easier to to give
    # up and use homebrew. Macfuse broke me. Maybe if I'd still use macs
    # fulltime, I'd have the patience to maintain my own packages.
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
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
    nix-darwin,
    ...
  }: {
    packages."x86_64-linux" = let
      legacyPackages = nixpkgs.legacyPackages."x86_64-linux";
    in rec {
      cosmocc = legacyPackages.callPackage ./pkgs/cosmocc.nix {};
      llamafile = legacyPackages.callPackage ./pkgs/llamafile.nix {cosmocc = cosmocc;};
    };

    packages."x86_64-darwin" = let
      legacyPackages = nixpkgs.legacyPackages."x86_64-darwin";
    in {
      firefox-darwin = legacyPackages.callPackage ./modules/firefox-darwin {};
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

    darwinConfigurations.lorien = nix-darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      specialArgs = {
        inherit self;
        inherit inputs;
      };
      modules = [
        ./machines/lorien-macbookpro-2017/configuration.nix
        ./modules/development
        home-manager.darwinModules.home-manager
        {
          home-manager.extraSpecialArgs = {inherit self;};
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.kuglimon = {...}: {
            imports = [./machines/lorien-macbookpro-2017/home.nix];
          };
        }
      ];
    };
  };
}
