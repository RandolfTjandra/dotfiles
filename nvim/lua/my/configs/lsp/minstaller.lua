local M = {}

function M.setup()
  local masonLspconfig = require("mason-lspconfig")

  masonLspconfig.setup({
    ensure_installed = {
      "ansiblels",
      "bashls",
      "cssls",
      "dockerls",
      "eslint",
      "gopls",
      "jsonls",
      "lua_ls",
      "sqlls",
      "tsserver",
    },
  })



  -- old

  local lsp_installer = safe_require("mason-lspconfig")
  if not lsp_installer then
    return
  end

  local handlers = require("my.configs.lsp.handlers")

  lsp_installer.on_server_ready(function(server)
    local opts = server:get_default_options()
    opts.on_attach = handlers.on_attach
    opts.capabilities = handlers.capabilities

    server:setup(opts)
  end)
end

return M
