# My development setup. Built for machines with a GUI.
{
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
        # Helper for sandboxing ai agents
        aisabox

        # Main reason I use alacritty is that it works on all platforms I use
        # (windows, macos, linux).
        alacritty
        alacritty-theme

        # Mostly using for reverse engineering
        gdb

        # For sandboxing applications
        nixos-shell

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
        vagrant

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
              packages.myVimPackage =
                let
                  vp = pkgs.vimPlugins;
                in
                {
                  start = [
                    vp.catppuccin-nvim
                    vp.popup-nvim
                    vp.plenary-nvim
                    vp.telescope-fzf-native-nvim
                    vp.telescope-nvim
                    vp.comment-nvim
                    vp.luasnip
                    vp.nvim-cmp

                    # Completions from current buffer
                    vp.cmp-buffer

                    # LSP completions
                    vp.cmp-nvim-lsp

                    # Completions for Neovim Lua with natural 20 roll for int
                    vp.cmp-nvim-lua

                    # Path based completions
                    vp.cmp-path

                    # Completions from snippets
                    vp.cmp_luasnip
                    vp.neodev-nvim
                    vp.nvim-lspconfig
                    (vp.nvim-treesitter.withAllGrammars)
                    vp.nvim-treesitter-textobjects

                    # EasyMotion/Sneak alternative. Allows for searching based on two
                    # characters like in sneak but can search globaly in windows with 'g'
                    # prefix
                    vp.leap-nvim
                    vp.none-ls-nvim
                    vp.oil-nvim

                    # Lords plugins
                    vp.vim-fugitive
                    vp.vim-surround
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

            # For clangd LSP
            clang-tools

            # Hourly consultants hate this tool
            ruff

            # typescript LSP
            vtsls
          ];
          text = ''
            ${wrappedNeovim}/bin/nvim "$@"
          '';
        }
      )
    ];

    programs.zsh.enable = true;

    bundles.unfreePackages = [
      "vagrant"
    ];
  };
}
