--
-- General options
--
-- NeoVim has enabled some of the configurations I used to have:
--  * filetype plugin indent on
--  * syntax enable/on

vim.opt.encoding = "utf-8"
vim.o.backspace = "2" -- Backspace deletes like most programs in insert mode
vim.o.backup = false
vim.o.writebackup = false

vim.o.swapfile = false -- http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
vim.o.backup = false

vim.o.history = 50
vim.o.ruler = true     -- show the cursor position all the time
vim.o.showcmd = true   -- display incomplete commands
vim.o.laststatus = 2   -- Always display the status line
vim.o.autowrite = true -- Automatically :write before running commands
vim.o.winwidth = 100

-- Softtabs, 2 spaces
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.shiftround = true
vim.o.expandtab = true

-- Display extra whitespace
vim.o.list = true
vim.o.listchars = [[tab:»·,trail:·,nbsp:·]]

-- Make it obvious where 80 characters is
vim.o.textwidth = 80
vim.o.formatoptions = vim.o.formatoptions:gsub('tc', '')
vim.o.colorcolumn = "+1"

-- Open new split panes to right and bottom, which feels more natural
vim.o.splitbelow = true
vim.o.splitright = true

-- turn hybrid line numbers on
vim.o.number = true
vim.o.rnu = true
vim.o.numberwidth = 3

-- sync clipboard between OS and Neovim
vim.o.clipboard = 'unnamedplus'

-- Always use vertical diffs
vim.opt.diffopt:append { 'vertical' }

-- enable smart indentation. This will indent wrapped lines.
vim.o.breakindent = true

-- Enable wrapping. I keep going flipping this on and of.
vim.o.wrap = false
vim.o.breakindent = true

-- Always leave some padding above and below the cursor. It took me like 10
-- years to find this! Always hated how it worked by default.
vim.o.scrolloff = 8

vim.o.hlsearch = false
vim.o.incsearch = true -- do incremental searching

vim.o.updatetime = 50

vim.o.completeopt = 'menuone,noselect'

-- Fix the version of node I use with vim. I run a ton of different versions of
-- node, oldest ones being something like v8. For example pyright doesn't even
-- work on older versions of node. And many projects are a mix of node and
-- python.
--
-- This has some downsides which will surely bite me in the ass. If I run
-- commands through vim I suspect they will use this version, which of course
-- might not have the tools I expect it to have.
vim.cmd([[
let $PATH = $HOME . '/.nodenv/versions/14.15.3/bin:' . $HOME . '/.pyenv/versions/vim-3.9.5/bin:'. $PATH
]])

-- TODO: is this even required anymore
-- Treat <li> and <p> tags like the block tags they are
vim.cmd([[
let g:html_indent_tags = 'li\|p'
]])
