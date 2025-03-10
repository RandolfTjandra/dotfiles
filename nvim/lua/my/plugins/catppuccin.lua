---@module "lazy"

---@type LazySpec
local P = {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
}

function P.config()
  local catppuccin = require("catppuccin")

  catppuccin.setup()

  require("my.configs.catppuccin").setup()
end

return P
