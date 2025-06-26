# My development setup. Built for machines with a GUI.
{
  self,
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    bundles.development = {
      enable = lib.mkEnableOption "Enables development tools";
    };
  };

  config = lib.mkIf config.bundles.development.enable {
    # FIXME(tatu): Different systems have different users, this should be
    # configurable.
    users.users.kuglimon = {
      packages = with pkgs; [
        # Main reason I use alacritty is that it works on all platforms I use
        # (windows, macos, linux).
        alacritty
        alacritty-theme

        # Mostly using for reverse engineering
        gdb

        bat
        cargo
        fzf
        git
        git-crypt
        git-lfs
        imagemagick
        jq
        killall
        ripgrep
        rustc
        rustfmt
        tmux
        tree
        unzip
        xclip

        # Testing out the cursed editor
        code-cursor

        # I didn't configure these using program.zsh nor program.starship as I'm
        # not a fan of having another layer of abstraction on top of the
        # configuration.
        #
        # I want to find my .zshrc in $HOME and have a starship.toml
        # configuration, not some bespoke nix configuration.
        zsh
        zsh-completions
        starship
      ];
    };

    environment.systemPackages = with pkgs; [
      # Big boi config
      (
        let
          wrappedNeovim = neovim.override {
            withNodeJs = true;
            configure = {
              customRC = ''
                luafile ~/.config/nvim/init.lua
              '';
              # XXX(tatu): The fuck is this package name supposed to be?
              packages.myVimPackage = with pkgs.vimPlugins; {
                start = [
                  catppuccin-nvim
                  popup-nvim
                  plenary-nvim
                  telescope-fzf-native-nvim
                  telescope-nvim
                  comment-nvim
                  luasnip
                  nvim-cmp

                  # Completions from current buffer
                  cmp-buffer

                  # LSP completions
                  cmp-nvim-lsp

                  # Completions for Neovim Lua with natural 20 roll for int
                  cmp-nvim-lua

                  # Path based completions
                  cmp-path

                  # Completions from snippets
                  cmp_luasnip
                  neodev-nvim
                  nvim-lspconfig
                  (nvim-treesitter.withAllGrammars)
                  nvim-treesitter-textobjects
                  playground

                  # EasyMotion/Sneak alternative. Allows for searching based on two
                  # characters like in sneak but can search globaly in windows with 'g'
                  # prefix
                  leap-nvim
                  none-ls-nvim
                  oil-nvim

                  # Lords plugins
                  fugitive
                  vim-surround
                ];
              };
            };
          };
        in
        pkgs.writeShellApplication {
          name = "nvim";
          runtimeInputs = [
            rust-analyzer
            # For js LSP
            biome

            # nix formatter
            alejandra

            # already contains shellcheck
            bash-language-server
            terraform-ls
            nil
            lua-language-server

            # ts LSP
            vtsls
          ];
          text = ''
            ${wrappedNeovim}/bin/nvim "$@"
          '';
        }
      )
    ];

    programs.zsh.enable = true;
  };
}
