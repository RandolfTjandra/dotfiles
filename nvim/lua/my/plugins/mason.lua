---@module "lazy"

---@type LazySpec
local P = {
  "williamboman/mason.nvim",
  cmd = {
    "Mason",
    "MasonInstall",
    "MasonUninstall",
    "MasonUninstallAll",
    "MasonUpdate",
    "MasonLog",
  },
}

function P.config()
  require("mason").setup()
end

return P
