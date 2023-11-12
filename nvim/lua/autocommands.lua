--
-- Autocommands
--
-- TODO I should go through these, no idea if any of these are even valid
--      anymore.

vim.cmd([[
augroup vimrcEx
  " reset autocommands so sourcing .vimrc multiple times won't work wonky
  autocmd!

  " vimwiki new diary template
  autocmd BufNewFile ~/vimwiki/diary/*.md :silent 0r !echo "\# `date +'\%Y-\%m-\%d'`"

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

  " Don't show tabs in go files
  autocmd FileType go setlocal noexpandtab
  autocmd FileType go setlocal list
  autocmd FileType go setlocal listchars=tab:\ \ ,trail:·,nbsp:·

  " When opening files from wiki change the window location to the file location
  " I tend to modify wiki entries from all over the place. I never navigate to
  " the wiki folder and just start editing from there. This is to ease writing
  " other commands. Since we know that we're always in the wiki directory.
  autocmd BufEnter ~/vimwiki/* silent lcd %:p:h

  " Fetch changes from git when opening files. This does make opening entries
  " a tad slower but it's better than having to remember to update them.
  " And usually I open the diary entry for today and edit that. Rarely am I
  " opening a bunch of files from wiki.
  "
  " This also has the cool upside of letting you know that something has indeed
  " changed from what you had. Let's say I work on the desktop during the
  " morning. Then later on during the day I switch to my laptop and open the
  " diary entry for today through the shortcut. At this point I would get a
  " message saying that the file I'm editing has changed, do I want to load it.
  autocmd BufEnter ~/vimwiki/* silent execute "!git fetch && git rebase origin/master" | redraw!

  " On save add and commit all vimwiki changes to git. Usually this is pretty
  " darn fast. So I'll just do it on every save.
  autocmd BufWritePost ~/vimwiki/* silent execute "!git add -A && git commit -m \"Auto commit from $HOST of %:t.\" && git push > /dev/null" | redraw!

  " remove trailing whitespace on save
  " autocmd BufWritePre * %s/\s\+$//e
augroup END
]])
