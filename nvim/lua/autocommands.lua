--
-- Autocommands
--
-- TODO I should go through these, no idea if any of these are even valid
--      anymore.

vim.cmd([[
augroup vimrcEx
  " reset autocommands so sourcing .vimrc multiple times won't work wonky
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.jb setfiletype ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown

  " Automatically wrap at 80 characters for Markdown
  autocmd BufRead,BufNewFile *.md setlocal textwidth=80

  " Automatically wrap at 72 characters and spell check git commit messages
  autocmd FileType gitcommit setlocal textwidth=72
  autocmd FileType gitcommit setlocal spell

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-

  " Don't show tabs in go or lua files
  autocmd FileType go setlocal noexpandtab
  autocmd FileType go,lua setlocal list
  autocmd FileType go,lua setlocal listchars=tab:\ \ ,trail:·,nbsp:·

  " remove trailing whitespace on save
  autocmd BufWritePre * %s/\s\+$//e
augroup END
]])
