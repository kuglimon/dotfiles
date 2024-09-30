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
  -- init playground, used for testing treesitter queries
  playground = {
    enable = true,
    disable = {},
    updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }
}
