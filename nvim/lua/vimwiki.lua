--
-- vimwiki configuration
--

vim.cmd([[
" Use markdown for vimwiki format
let g:vimwiki_list = [{'path': '~/vimwiki/', 'index': 'README',
                      \ 'syntax': 'markdown', 'ext': '.md'}]

let wiki_1 = {}
let wiki_1.path = '~/vimwiki/'
let wiki_1.syntax = 'markdown'
let wiki_1.ext = '.md'
]])
