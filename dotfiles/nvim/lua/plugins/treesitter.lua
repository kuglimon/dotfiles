--
-- syntax highlighting configuration
--
-- Tree sitter provides the configuration for syntax highlighting. It also seems
-- to do filetype detection, which other plugins like LSP require.
--

-- Enable tree-sitter highlighting globally
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local bufnr = args.buf
    local lang = vim.treesitter.language.get_lang(args.match)

    -- Check if parser exists for this language
    local ok = pcall(vim.treesitter.start, bufnr, lang)
    if not ok then
      return
    else
      -- Disable additional vim regex highlighting
      vim.bo[bufnr].syntax = ""
    end
  end,
})
