{ inputs, ... }: {
  imports = with inputs; [
    home-manager.nixosModules.home-manager
  ];

  nixpkgs.config.allowUnfree = true;

  # home-manager options
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.kuglimon = { ... } :{
    imports = [../../machines/kuglimon-desktop/home.nix];
  };
}

