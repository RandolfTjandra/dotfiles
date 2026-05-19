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
  local install_dir = vim.fs.normalize(vim.fn.stdpath("data") .. "/site")

  if not vim.list_contains(vim.opt.runtimepath:get(), install_dir) then
    vim.opt.runtimepath:prepend(install_dir)
  end

  treesitter.setup({
    install_dir = install_dir,
  })

  if vim.fn.executable("tree-sitter") == 0 then
    vim.notify(
      "nvim-treesitter main requires tree-sitter-cli on PATH; install it to build parsers",
      vim.log.levels.WARN
    )
  elseif type(treesitter.install) == "function" then
    treesitter.install(parsers)
  else
    vim.notify("nvim-treesitter main install API not found", vim.log.levels.WARN)
  end

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
