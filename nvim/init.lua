vim.opt.directory = vim.fn.expand("$XDG_CACHE_HOME/nvim")

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

-- local colorscheme = vim.g.my_colorscheme or "dracula-soft"
local colorscheme = vim.g.my_colorscheme or "catppuccin"
local ok, err = pcall(vim.cmd.colorscheme, colorscheme)
if not ok then
  vim.notify(
    string.format("Failed to load colorscheme '%s': %s", colorscheme, err),
    vim.log.levels.WARN
  )
end
