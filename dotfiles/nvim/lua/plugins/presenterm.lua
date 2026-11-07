require("presenterm").setup({
  default_keybindings = true,
  picker = {
    provider = "telescope",
  },
  preview = {
    command = "presenterm -xX",
    presentation_preview_sync = true,
  },
})
