---@module "lazy"

---@type LazySpec
local P = {
  "zbirenbaum/copilot.lua",
  event = "InsertEnter",
  cmd = { "Copilot" },
}

function P.config()
  local copilot = require("copilot")

  local config = {
    panel = { enabled = false },
    suggestion = { enabled = false },
    filetypes = {
      yaml = false,
      markdown = false,
      help = false,
      gitcommit = false,
      gitrebase = false,
      hgcommit = false,
      svn = false,
      cvs = false,
      ["."] = false,
    },
    copilot_node_command = "node", -- Node.js version must be > 18.x
    server_opts_overrides = {},
  }

  copilot.setup(config)
end

return P
