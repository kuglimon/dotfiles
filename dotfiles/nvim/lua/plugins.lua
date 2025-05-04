--
-- Plugins/modules
--

-- There's no plugin installation in my Neovim config. Nix handles the actual
-- plugin installation and there's no plugin manager in use - thank fucking god.
--
-- Plugin managers were a pain in vim/neovim:
-- * New plugin every year (subjective)
-- * Constant random failures on plugin install
-- * Plugins don't update with the system
--  * Never actually update plugins
--
-- Configuration reduces down to just splitting stuff to plugin specific
-- configuration modules.
vim.cmd([[colorscheme catppuccin-mocha]])

require('plugins.telescope')
require('Comment').setup()
require('plugins.treesitter')
require('plugins.lsp')
require('leap').create_default_mappings()
require('plugins.oil')
