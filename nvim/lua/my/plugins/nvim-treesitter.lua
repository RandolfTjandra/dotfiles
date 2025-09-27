---@module "lazy"

---@type LazySpec
local P = {
  "nvim-treesitter/nvim-treesitter",
  run = ":TSUpdate",
  event = "BufRead",
  cmd = {
    "TSInstall",
    "TSInstallInfo",
    "TSInstallSync",
    "TSUninstall",
    "TSUpdate",
    "TSUpdateSync",
    "TSDisableAll",
    "TSEnableAll",
  },
}

function P.config()
  local treesitter = require("nvim-treesitter.configs")

  treesitter.setup({
    ensure_installed = {
      "bash",
      "c",
      "cpp",
      "css",
      "dockerfile",
      "go",
      "gomod",
      "gosum",
      "html",
      "javascript",
      "jq",
      "json",
      "lua",
      "markdown",
      "php",
      "python",
      "regex",
      "rust",
      "scss",
      "sql",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
    },
    sync_install = false,
    ignore_install = { "help" },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
    autopairs = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
    },
    indent = {
      enable = true,
    },
    rainbow = {
      enable = true,
      disable = { "html" },
      extended_mode = false,
      max_file_lines = nil,
    },
    autotag = {
      enable = true,
    },
  })
end

return P
