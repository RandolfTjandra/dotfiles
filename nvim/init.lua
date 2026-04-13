vim.opt.directory = vim.fn.expand("$XDG_CACHE_HOME/nvim")

-- Give Neovim and plugins a stable writable runtime dir for RPC sockets.
local state_home = vim.env.XDG_STATE_HOME or vim.fn.expand("~/.local/state")
local runtime_dir = vim.fs.normalize(state_home .. "/nvim/run")
if vim.fn.isdirectory(runtime_dir) == 0 then
  vim.fn.mkdir(runtime_dir, "p")
end
vim.env.XDG_RUNTIME_DIR = runtime_dir

local python3_host = vim.fn.exepath("python3")
if python3_host ~= "" then
  vim.g.python3_host_prog = python3_host
end

function _G.safe_require(module)
  local ok, result = pcall(require, module)
  if not ok then
    vim.notify(string.format("Error requiring: %s", module), vim.log.levels.ERROR)
    return ok
  end
  return result
end

-- require("my.plugins")
require("my.general")
require("my.mappings")

require("my.lazy")

local colorscheme = vim.g.my_colorscheme or "dracula"
local ok, err = pcall(vim.cmd.colorscheme, colorscheme)
if not ok then
  vim.notify(
    string.format("Failed to load colorscheme '%s': %s", colorscheme, err),
    vim.log.levels.WARN
  )
end
