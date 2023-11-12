--
-- Plugins/modules
--
return require('packer').startup(function(use)
  use {
    'dracula/vim',
    as = 'dracula',
    config = function()
      vim.cmd('colorscheme dracula')
    end
  }

  use { "wbthomason/packer.nvim" }

  -- Telescope uses popup and plenary, plenary used by other plugins as well
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'

  use 'nvim-telescope/telescope.nvim'

  -- this compiles a c port of the fzf algorithm for use with telescope, makes
  -- search faster
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  use {
    "williamboman/mason.nvim", -- mason helps with installing LSP
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",   -- Configurations for Nvim LSP
  }

  -- LSP autocomplete
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'

  -- Additional lua configuration, makes nvim stuff amazing!
  use { 'folke/neodev.nvim' }

  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'nvim-treesitter/nvim-treesitter-textobjects' }
  use { 'nvim-treesitter/playground' }

  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }
end)
