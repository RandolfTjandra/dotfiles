---@module "lazy"

---@type LazySpec
local P = {
  "norcalli/nvim-colorizer.lua",
}

function P.config()
  local colorizer = require("colorizer")

  colorizer.setup({ "*" }, {
    RGB = true,
    RRGGBB = true,
    names = false,
    RRGGBBAA = false,
  })
end

return P
