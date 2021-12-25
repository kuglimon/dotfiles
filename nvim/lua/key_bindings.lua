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
