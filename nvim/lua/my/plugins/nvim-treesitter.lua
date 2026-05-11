---@module "lazy"

local parsers = {
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
  "query",
  "regex",
  "rust",
  "scss",
  "sql",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
}

local filetypes = {
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
  "javascriptreact",
  "jq",
  "json",
  "lua",
  "markdown",
  "php",
  "python",
  "query",
  "regex",
  "rust",
  "scss",
  "sql",
  "toml",
  "typescript",
  "typescriptreact",
  "vim",
  "vimdoc",
}

---@type LazySpec
local P = {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    "neovim-treesitter/treesitter-parser-registry",
  },
}

function P.config()
  local treesitter = require("nvim-treesitter")
  local group = vim.api.nvim_create_augroup("MyTreesitter", { clear = true })

  treesitter.setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
  })

  treesitter.install(parsers)

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = filetypes,
    callback = function(args)
      local ok = pcall(vim.treesitter.start, args.buf)
      if not ok then
        return
      end

      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  })
end

return P
