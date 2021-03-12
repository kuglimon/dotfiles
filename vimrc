scriptencoding utf-8
set encoding=utf-8

let mapleader = " "  " Leader to space

set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands

set winwidth=100

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

filetype plugin indent on

color dracula

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
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

augroup vimrcEx
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

  " FIXME: This tries to run the commands in CWD. Thats no bueno!
  "au! BufWritePost ~/vimwiki/* !git add "%";git commit -m "Auto commit of %:t." "%"
augroup END


" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Make it obvious where 80 characters is
set textwidth=80
set formatoptions-=tc
set colorcolumn=+1

" turn hybrid line numbers on
set number relativenumber
set nu rnu
set numberwidth=3

" Use markdown for vimwiki format
let g:vimwiki_list = [{'path': '~/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]

let wiki_1 = {}
let wiki_1.path = '~/vimwiki/'
let wiki_1.syntax = 'markdown'
let wiki_1.ext = '.md'

" You need to learn, son
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" FZF mappings
" Quickly find in files
nnoremap <Leader>s :Rg<CR>

" Use FZF like ctrlp
nnoremap <C-p> :Files<Cr>

" Search vimwiki with fzf
nnoremap <Leader>n :Files ~/vimwiki<Cr>
nnoremap <Leader>m :Rg ~/vimwiki<Cr>

" FIXME: This shit doesn' work brah
command! -bang -nargs=* PRg
  \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'dir': '~/vimwiki'}, <bang>0)

" vim-rspec mappings
nnoremap <Leader><Leader>t :call RunCurrentSpecFile()<CR>
nnoremap <Leader><Leader>s :call RunNearestSpec()<CR>
nnoremap <Leader><Leader>l :call RunLastSpec()<CR>
map <Leader><Leader>a :call RunAllSpecs()<CR>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" Always use vertical diffs
set diffopt+=vertical

" so pasting in tmux works
set clipboard=unnamed

let g:rspec_command = "!bundle exec rspec -f d -c {spec}"

" Put this in vimrc or a plugin file of your own.
" After this is configured, :ALEFix will try and fix your JS code with ESLint.
let g:ale_fixers = {
\   'javascript': ['prettier', 'eslint'],
\   'rust': ['rustfmt']
\}
let g:ale_linters = {'rust': ['analyzer']}

" Only run ale on save
let g:ale_fix_on_save = 1
" Run only the linters we've specified
"let g:ale_linters_explicit = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0

" enable smart indentation. This will indent wrapped lines.
set breakindent

" remove trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

let g:table_mode_corner='|'

set nocompatible
