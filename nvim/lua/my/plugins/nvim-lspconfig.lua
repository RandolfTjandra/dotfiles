---@module "lazy"

---@type LazySpec
local P = {
  "neovim/nvim-lspconfig",
}

P.dependencies = {
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  -- Depends on fzf for some lsp keyboard mappings
  "ibhagwan/fzf-lua",
}

function P.config()
  local masonLspconfig = require("mason-lspconfig")
  local lspconfig_configs = require("lspconfig.configs")
  local servers = {
    "ansiblels",
    "bashls",
    "basedpyright",
    "biome",
    "cssls",
    "dockerls",
    "eslint",
    "gopls",
    "jsonls",
    "lua_ls",
    "pyright",
    "ruff",
    "rust_analyzer",
    "sqlls",
    "ts_ls",
    "yamlls",
  }

  masonLspconfig.setup({
    ensure_installed = servers,
    automatic_enable = false,
  })

  require("lspconfig.ui.windows").default_options.border = "rounded"

  -- Fix float border highlight group for LspInfo
  vim.api.nvim_set_hl(0, "LspInfoBorder", { link = "FloatBorder" })

  local function on_attach(client, bufnr)
    require("my.mappings").lsp_mapping(bufnr)
  end

  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  local function configure(server_name, opts)
    opts = opts or {}
    opts.on_attach = on_attach
    opts.capabilities = capabilities

    if lspconfig_configs[server_name] == nil then
      lspconfig_configs[server_name] = require("lspconfig.configs." .. server_name)
    end
    lspconfig_configs[server_name].setup(opts)
  end

  for _, server_name in ipairs(servers) do
    if server_name == "basedpyright" then
      configure("basedpyright", {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              diagnosticMode = "openFilesOnly",
              reportUnusedVariable = "none",
              reportUnusedCallResult = "none",
            },
          },
        },
      })
    elseif server_name == "biome" then
      configure("biome", {
        -- Keep biome on the web stack, but let jsonls handle plain JSON files.
        filetypes = {
          "astro",
          "css",
          "graphql",
          "html",
          "javascript",
          "javascriptreact",
          "svelte",
          "typescript",
          "typescriptreact",
          "vue",
        },
      })
    else
      configure(server_name)
    end
  end

  local signs = {
    { name = "DiagnosticSignError", text = "━" },
    { name = "DiagnosticSignWarn", text = "━" },
    { name = "DiagnosticSignHint", text = "━" },
    { name = "DiagnosticSignInfo", text = "━" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local diagnostics_config = {
    virtual_text = false,
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    signs = {
      active = signs,
    },
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(diagnostics_config)

  vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

  vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
end

return P
