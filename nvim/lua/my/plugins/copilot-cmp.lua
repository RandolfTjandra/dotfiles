---@module "lazy"

---@type LazySpec
local P = {
  "zbirenbaum/copilot-cmp",
}

function P.config()
  local copilot_cmp = require("copilot_cmp")

  copilot_cmp.setup()
end

return P

