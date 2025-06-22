--
-- Auto-completion support (nvim-cmp + NeoVim LSP)
--

--
-- LSP configuration
--
local nvim_lsp = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- LSP settings.
-- This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  -- Function that lets us more easily define mappings specific for LSP related
  -- items. Set mode, buffer and description.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  -- FIXME: config should support per LSP on_attach rather than iffing it here
  if client.name == "vtsls" then
    -- disable vtsls linting and let biome handle it
    client.server_capabilities.documentFormattingProvider = false
  end

  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format {}
      end,
    })
  end

  -- on mac this is opt-shift-l
  nmap('ﬂ', vim.lsp.buf.format, 'Format')

  -- refactoring crap
  nmap('<leader>rn', vim.lsp.buf.rename, '[R]efactor [N]ame')
  nmap('<leader>ra', vim.lsp.buf.code_action, '[R]efactor [A]ction')

  -- LSP based movements
  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('gD', vim.lsp.buf.type_definition, 'Type [D]efinition')

  -- neovim diagnostic bindings
  -- I started this with dj and dk but I kept butter fingering it to delete all
  -- the time and that was just fucking annoying. Rather move a line by accident
  -- than delete a line
  nmap('<leader>j', vim.diagnostic.goto_next, 'Diagnostic [J]Next')
  nmap('<leader>k', vim.diagnostic.goto_prev, 'Diagnostic [K]Previous')
  nmap('<leader>ll', "<cmd>Telescope diagnostics<cr>", 'Telescope list diagnostics')

  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
end

-- List of installed language servers and their configurations. Please make sure
-- any system specific configurations are installed through nix.
--
-- TODO(tatu): Move this configuration to nix and generate a lua file from nix?
--             This would keep the related code closer together.
local servers = {
  bashls = {},
  terraformls = {},
  nil_ls = {
    ["nil"] = {
      nix = {
        flake = {
          -- calls `nix flake archive` to put a flake and its output to store
          -- otherwise we'll get errors of completion
          autoArchive = false,
          -- auto eval flake inputs for improved completion.
          -- FIXME(tatu): enabling tthis says nix runs out of memory and I'm on
          --              a 64GB system, lefuck
          autoEvalInputs = false,
        },
      },
    },
  },
  rust_analyzer = {},
  vtsls = {},
  biome = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

for server, settings in pairs(servers) do
  nvim_lsp[server].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = settings
  }
end

-- nvim-cmp setup
local cmp = require('cmp')
local luasnip = require('luasnip')

luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<C-k>'] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  -- The order here matters. First item has highest priority.
  sources = {
    { name = 'nvim_lua' },
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'luasnip' },
    { name = 'buffer',  keyword_length = 3 },
  },
}

local null_ls = require("null-ls")

-- Other diagnostics through null-ls
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.biome,
  },
})
