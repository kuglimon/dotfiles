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

    home-manager = {
      url =  "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Helper for managing tmux layouts. It's a monorepo and this allows me to
    # pull just one project from a subdirectory.
    rojekti = {
      url = "github:UncertainSchrodinger/molokki?dir=rojekti";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nix-darwin, ... }: {

    packages."x86_64-linux" = let
      legacyPackages = nixpkgs.legacyPackages."x86_64-linux";
    in
    rec {
      cosmocc = legacyPackages.callPackage ./pkgs/cosmocc.nix { };
      llamafile = legacyPackages.callPackage ./pkgs/llamafile.nix { cosmocc = cosmocc; };
      vtsls = legacyPackages.callPackage ./pkgs/vtsls.nix { };
    };

    packages."x86_64-darwin" = let
      legacyPackages = nixpkgs.legacyPackages."x86_64-darwin";
    in {
      firefox-darwin = legacyPackages.callPackage ./modules/firefox-darwin { };
      vtsls = legacyPackages.callPackage ./pkgs/vtsls.nix { };
    };

    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit self; inherit inputs; };
      modules = [
        ./modules/development
        ./modules/gaming
        ./machines/kuglimon-desktop/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.kuglimon = { ... } :{
            imports = [./machines/kuglimon-desktop/home.nix];
          };
        }
      ];
    };

    nixosConfigurations.watermedia = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit self; inherit inputs; };
      modules = [
        ./machines/watermedia-elitedesk/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.kuglimon = { ... } :{
            imports = [./machines/watermedia-elitedesk/home.nix];
          };
        }
      ];
    };

    darwinConfigurations.lorien = nix-darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      specialArgs = { inherit self; inherit inputs; };
      modules = [
        ./machines/lorien-macbookpro-2017/configuration.nix
	      home-manager.darwinModules.home-manager
        {
          home-manager.extraSpecialArgs = { inherit self; };
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.kuglimon = { ... } :{
            imports = [./machines/lorien-macbookpro-2017/home.nix];
          };
        }
      ];
    };
  };
}
