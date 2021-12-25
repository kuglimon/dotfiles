--
-- fzf configuration
--

vim.cmd([[
" FZF mappings
" Quickly find in files
nnoremap <Leader>s :Rg<CR>

" Use FZF like ctrlp
nnoremap <C-p> :Files<Cr>

" Search vimwiki with fzf
nnoremap <Leader>n :Files ~/vimwiki<Cr>
nnoremap <Leader>m :RgWiki <Cr>

" Searches content in my VimWiki
command! -bang -nargs=* RgWiki call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case -- ".shellescape(<q-args>), 1, fzf#vim#with_preview({'dir': '~/vimwiki'}), <bang>0)
]])
