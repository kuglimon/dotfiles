--
-- fzf configuration
--
-- Quick reference to binginds
--
-- <C-p>      search files but respect gitignore
-- <C-j>      search all files
-- <Leader>s  user ripgrep to search

vim.cmd([[
" FZF mappings
" Quickly find in files
nnoremap <Leader>s :Rg<CR>

" View files but respect gitignore
nnoremap <silent> <C-p> :GFiles --cached --others --exclude-standard<cr>

" Search for all files
nnoremap <C-j> :Files<Cr>

" Search vimwiki with fzf
" nnoremap <Leader>n :Files ~/vimwiki<Cr>
" nnoremap <Leader>m :RgWiki <Cr>

"command! -bang -nargs=* RgWiki call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case -- ".shellescape(<q-args>), 1, fzf#vim#with_preview({'dir': '~/vimwiki'}), <bang>0)

" Searches content in my VimWiki
"command! -bang -nargs=* RgWiki call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case -- ".shellescape(<q-args>), 1, fzf#vim#with_preview({'dir': '~/vimwiki'}), <bang>0)
]])
