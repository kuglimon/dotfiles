--
-- Key bindings/mappings
--
-- Not all bindings are here. Some are defined in their plugin configuration.
-- For example LSP contains its own mappings.
--
-- Try to keep generic configuration here and put plugin specific bindings to
-- the plugin configuration files. This way those key bindings are gone if I
-- ever decide to remove a plugin.

vim.g.mapleader = " " -- leader to space

-- Tab completion
-- will insert tab at beginning of line,
-- will use completion if not at beginning
vim.cmd([[
set wildmode=list:longest,list:full
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>
]])

vim.cmd([[
" These bindings are a relic from when I started to learn vim.
" I left these here in case anyone else decides to copy this config.
" Initially this really does help learning vim.
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>
]])

-- Move visual selections
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor position when joining
vim.keymap.set("n", "J", "mzJ`z")

-- Keep cursor centered when moving pages
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Keep cursor centered when searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste but keep the original yanked stuff after. God, I don't even know how
-- I lived so long without this.
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Yank to clipboard
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("n", "Q", "<nop>")

-- Find and replace on the current word under the cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Toggling between files is ctrl+6 in Finnish layout

-- This doesn't work but would be godlike. Search and replace over a selection.
-- vim.keymap.set("v", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- EXPERIMENTAL
--
-- These are keymappings I'm testing, might go away, might forget they exist
-- after 200ms.

-- C-6 is such a pain in the to type on a regular keyboard
vim.keymap.set("n", "<leader>a", "<C-6>", { desc = "Alternate between buffers" })
