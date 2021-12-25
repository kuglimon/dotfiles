--
-- Polytest
--
-- TODO this should support running tests in multiple different languages

vim.cmd([[
" vim-rspec mappings
nnoremap <Leader><Leader>t :call RunCurrentSpecFile()<CR>
nnoremap <Leader><Leader>s :call RunNearestSpec()<CR>
nnoremap <Leader><Leader>l :call RunLastSpec()<CR>
map <Leader><Leader>a :call RunAllSpecs()<CR>
]])
