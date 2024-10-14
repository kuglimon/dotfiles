{ inputs, ... }: {
  # TODO(tatu): maybe is should just drop home-manager completely. I use it for
  # like firefox profiles and that's it. There's probably another way to install
  # dotfiles without it.
  imports = with inputs; [
    home-manager.nixosModules.home-manager
  ];

  # home-manager options
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.kuglimon = { ... } :{
    imports = [../../machines/kuglimon-desktop/home.nix];
  };
}

