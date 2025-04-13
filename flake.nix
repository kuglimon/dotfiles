{
  description = "My machine configurations";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
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
    ...
  }: {
    packages."x86_64-linux" = let
      legacyPackages = nixpkgs.legacyPackages."x86_64-linux";
    in rec {
      cosmocc = legacyPackages.callPackage ./pkgs/cosmocc.nix {};
      llamafile = legacyPackages.callPackage ./pkgs/llamafile.nix {cosmocc = cosmocc;};
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
  };
}
