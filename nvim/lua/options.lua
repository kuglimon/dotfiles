--
-- General options
--
-- NeoVim has enabled some of the configurations I used to have:
--  * filetype plugin indent on
--  * syntax enable/on
--
-- This is why some of these are missing

vim.o.encoding = "utf-8"
vim.o.backspace = "2" -- Backspace deletes like most programs in insert mode
vim.o.backup = false
vim.o.writebackup = false

vim.o.swapfile = false -- http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
vim.o.history = 50
vim.o.ruler = true -- show the cursor position all the time
vim.o.showcmd = true -- display incomplete commands
vim.o.incsearch = true -- do incremental searching
vim.o.laststatus = 2  -- Always display the status line
vim.o.autowrite = true -- Automatically :write before running commands
vim.o.winwidth = 100

-- Softtabs, 2 spaces
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.shiftround = true
vim.o.expandtab = true

-- Display extra whitespace
vim.o.list = true
-- TODO: Does this actually work
vim.o.listchars = [[tab:»·,trail:·,nbsp:·]]

-- Make it obvious where 80 characters is
vim.o.textwidth = 80
vim.o.formatoptions = vim.o.formatoptions:gsub('tc', '')
vim.o.colorcolumn = "+1"

-- Open new split panes to right and bottom, which feels more natural
vim.o.splitbelow = true
vim.o.splitright = true

-- This should fix clipboard not working when inside tmux but I'm not sure if
-- it's even required anymore. Previously I needed to have some
-- reattach-to-userspace plugin for tmux but I haven't had that in years. No
-- idea if this configuration was to be used together with it. Leaving this in
-- just in case.
vim.o.clipboard = 'unnamed'

-- Always use vertical diffs
vim.cmd([[set diffopt+=vertical]])

-- FIXME: install dracula
-- vim.cmd("color dracula")

-- enable smart indentation. This will indent wrapped lines.
vim.o.breakindent = true

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
