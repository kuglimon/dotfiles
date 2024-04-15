--
-- Plugins/modules
--

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- this compiles a c port of the fzf algorithm for use with telescope, makes
-- search faster
require("lazy").setup({
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme catppuccin-mocha]])
    end,
  },
  { 'nvim-lua/popup.nvim' },
  { 'nvim-lua/plenary.nvim' },
  { 'nvim-telescope/telescope-fzf-native.nvim' },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzf-native.nvim',
    },
    config = function()
      require('plugins.telescope')
    end,
    cmd = 'Telescope',
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim"
    },
  },
  {
    'numToStr/Comment.nvim',
    init = function()
      require('Comment').setup()
    end
  },
  { 'L3MON4D3/LuaSnip' },
  -- The actual completion plugin. Dependencies provide connection to different
  -- sources. What these actualy do:
  --
  -- nvim-cmp: 'Framework' for plugins
  -- nvim-cmp-lsp: Completions from LSP
  -- nvim-cmp-lua: Completions for Neovim Lua with natural 20 roll for int
  -- nvim-path: Completions from file paths
  -- nvim-buffer: Completions from current buffer
  -- cmp_luasnip: Snippets
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip'
    },
  },
  { 'folke/neodev.nvim' },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      'hrsh7th/nvim-cmp'
    },
    config = function()
      require('plugins.lsp')
    end
  },
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/playground'
    },

    config = function()
      require('plugins.treesitter')
    end,
  },
  { 'nvim-treesitter/nvim-treesitter-textobjects' },
  { 'nvim-treesitter/playground' },
  {
    dir = '~/development/personal/git-worktree.nvim'
  },
  {
    -- EasyMotion/Sneak alternative. Allows for searching based on two
    -- characters like in sneak but can search globaly in windows with 'g'
    -- prefix
    'ggandor/leap.nvim',
    init = function()
      -- require('plugins.leap')
      require('leap').create_default_mappings()
    end,
  },
  { "nvimtools/none-ls.nvim" },
  {
    'nvim-orgmode/orgmode',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter', lazy = true },
    },
    event = 'VeryLazy',
    config = function()
      -- Setup treesitter
      require('nvim-treesitter.configs').setup({
        highlight = {
          enable = true,
        },
        ensure_installed = { 'org' },
      })

      -- Setup orgmode
      require('orgmode').setup({
        org_agenda_files = '~/orgfiles/**/*',
        org_default_notes_file = '~/orgfiles/refile.org',
      })
    end,
  },
  {
    'stevearc/oil.nvim',
    init = function()
      require("oil").setup()
    end
  }
})
