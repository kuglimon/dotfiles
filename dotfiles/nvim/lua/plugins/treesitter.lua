--
-- syntax highlighting configuration
--
-- Tree sitter provides the configuration for syntax highlighting. It also seems
-- to do filetype detection, which other plugins like LSP require.
--

require('nvim-treesitter.configs').setup {
  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- Disable in large lua buffers. These files are killing my old mac.
    disable = function(lang, bufnr)
      return lang == "lua" and vim.api.nvim_buf_line_count(bufnr) > 2500
    end,


    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
