---@module "lazy"

-- jdtls does not fit the generic server loop in `my.plugins.nvim-lspconfig`:
-- it needs a workspace directory keyed to the project root, so the client is
-- started per-buffer from `ftplugin/java.lua` instead. Keep "jdtls" out of the
-- `servers` list there or two clients will attach to every Java buffer.
---@type LazySpec
local P = {
  "mfussenegger/nvim-jdtls",
  ft = { "java" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "williamboman/mason.nvim",
    -- ftplugin/java.lua reuses the fzf-based lsp mappings
    "ibhagwan/fzf-lua",
  },
}

return P
