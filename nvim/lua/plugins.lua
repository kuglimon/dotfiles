--
-- Plugins/modules
--
local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

-- Library of NeoVim lua functions, plugins like null-ls require this
Plug 'nvim-lua/plenary.nvim'

-- Used to configure different LSP clients for NeoVim internal LSP. It has
-- support for multiple languages and can automatically build them.
Plug 'neovim/nvim-lspconfig'

-- I think these are different sources for autocompletion/suggestions. I'm not
-- sure if I need all of these. Documentation could be improved I guess.
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

vim.cmd([[
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
]])

-- Lua based snippets and the integration plugin for cmp. What I use this plugin
-- is to generate snippets through LSP clients - for example function signatures
-- when autocompleting code. There's supposed to be some community made snippets
-- and I could create my own snippets.
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'

-- For commenting code
Plug 'vim-scripts/tComment'

-- Provides an in-memory language server. This is used to allow tools without
-- their own language server to talk with NeoVim.
Plug 'jose-elias-alvarez/null-ls.nvim'

-- Could not get this to work through Lua.
-- Tree sitter, :TSUpdate signals to install all languages
vim.cmd([[
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
]])

-- Debugging support through DAP
Plug 'mfussenegger/nvim-dap'

vim.call('plug#end')
