-- Testing out NeoVim, mostly for LSP and tree sitter functionality
--
-- There's probably no reason to actually use lua for this configuration. But
-- I've never used Lua and wanted to learn it.

-- Order of these imports might be significant
require('key_bindings')
require('plugins')
require('options')
require('syntax')
require('autocompletion')
-- require('debugging')
require('autocommands')

-- Plugin specific configurations
-- require('plugins/firenvim')
-- require('fzf')
-- require('vimwiki')
-- require('polytest')

vim.cmd([[
  let g:rspec_command = "!bundle exec rspec -f d -c {spec}"
  let g:table_mode_corner='|'
]])

require('telescope').setup {
  defaults = {
    -- config_key = value,
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous"
      }
    }
  },
  pickers = {
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
  }
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fs', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})

-- Treat <li> and <p> tags like the block tags they are
vim.cmd([[
let g:html_indent_tags = 'li\|p'
]])
