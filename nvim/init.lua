-- Testing out NeoVim, mostly for LSP and tree sitter functionality
--
-- There's probably no reason to actually use lua for this configuration. But
-- I've never used Lua and wanted to learn it.


-- Order of these imports might be significant
require('plugins')
require('options')
require('key_bindings')
require('syntax')
require('autocompletion')

-- Plugin specific configurations
-- require('fzf')
-- require('vimwiki')
-- require('polytest')

-- vim.cmd([[
-- let g:rspec_command = "!bundle exec rspec -f d -c {spec}"
-- let g:table_mode_corner='|'
-- ]])

-- Treat <li> and <p> tags like the block tags they are
vim.cmd([[
let g:html_indent_tags = 'li\|p'
]])
