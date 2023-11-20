require('telescope').setup {
  defaults = {
    -- config_key = value,
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous"
      }
    }
  },
  pickers = {
  },
  extensions = {
    file_browser = {
      theme = "ivy",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
    },
    git_worktree = {},
  }
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- TODO: I don't really like that these keybindings are split around multiple
-- files. What I'd like is something like this in keysmaps.lua:
--
-- ```lua
-- loaded('telescope').setup({
--   init = function
--     local builtin = require('telescope.builtin')
--     vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
--   end,
-- })
-- ```
-- This should gracefully fail if plugin was not loaded.
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fs', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})

-- open file_browser with the path of the current buffer
vim.keymap.set("n", "<space>fb",
  ":Telescope file_browser path=%:p:h select_buffer=true<CR>"
)
