local M = {}

local keymap = vim.keymap.set

local fzf_winopts_bottom = {
  height = 0.3,
  width = 1,
  row = 1,
  col = 0,
  border = { "", "─", "", "", "", "", "", "" },
  preview = { horizontal = "right:50%" },
}

-- Remap ^C to behave like <Esc> in normal/insert modes and ignore r<C-c>.
keymap("n", "r<C-c>", "<Nop>")
keymap({ "n", "i" }, "<C-c>", "<Esc>")

-- Disable EX mode.
keymap("n", "Q", "<Nop>")

-- Window movement.
keymap("n", "<Tab>", "<C-W><C-w>")
keymap("n", "<S-Tab>", "<C-W><S-W>")

-- bufferline: Buffer management.
keymap("n", "<C-]>", "<cmd>bnext<CR>")
keymap("n", "<Esc>", "<cmd>bprev<CR>")

function M.bufferline_mapping()
  keymap("n", "<C-]>", "<cmd>bnext<CR>")
  keymap("n", "<Esc>", "<cmd>bprev<CR>")
end

-- bufdelete: Close buffers / quit with ^q.
keymap("n", "<C-q>", function()
  local buffers = {}

  for buffer = 1, vim.fn.bufnr("$") do
    if vim.fn.buflisted(buffer) == 1 then
      table.insert(buffers, buffer)
    end
  end

  if #buffers == 1 then
    vim.cmd("confirm quit")
  else
    vim.cmd("confirm Bdelete")
  end
end)

-- Do not move cursor when using *.
keymap("n", "*", "<cmd>let s = winsaveview()<CR>*<cmd>:call winrestview(s)<CR>")

-- Quick system copy and paste.
keymap("n", "<Leader>y", '"+y')
keymap("n", "<Leader>Y", '"+Y')
keymap("v", "<Leader>y", '"+y')

-- fzf mappings will be registered when the plugin loads.
function M.fzf_mapping(fzf)
  keymap("n", "<Leader><Leader>", fzf.git_files)
  keymap("n", "<Leader>p", fzf.files)
  keymap("n", "<Leader>b", fzf.buffers)
  keymap("n", "<Leader>f", fzf.live_grep_native)
  keymap("n", "<Leader>r", fzf.command_history)
end

-- nvim-tree.
keymap("n", "<Leader>t", "<cmd>NvimTreeFindFileToggle<CR>")

-- Toggle spelling.
keymap("n", "<Leader>s", "<cmd>set spell!<CR>")

-- Git integrations.
keymap("n", "gb", ":Git blame<CR>")
keymap("n", "gh", ":GBrowse!<CR>")
keymap("v", "gh", ":'<'>GBrowse!<CR>")

function M.substitute_mapping(substitute)
  keymap("n", "s", substitute.operator)
  keymap("n", "ss", substitute.line)
  keymap("n", "S", substitute.eol)
end

-- Yank filepath into system clipboard.
keymap("n", "<Leader>yp", function()
  vim.fn.setreg("+", vim.fn.expand("%:p"))
  vim.api.nvim_echo({ { "Path copied to system clipboard", "None" } }, false, {})
end)

-- Clear search.
keymap("n", "<C-l>", ":nohlsearch<CR>:call clearmatches()<CR>")

-- Repeat the last executed macro.
keymap("n", ",", "@@")

function M.lsp_mapping(bufnr)
  local fzf = require("fzf-lua")

  local function fzf_lsp(name, opts)
    local fn = fzf[string.format("lsp_%s", name)]
    return function()
      fn(opts or { winopts = fzf_winopts_bottom, jump1 = true })
    end
  end

  local buf_opts = { buffer = bufnr }

  keymap("n", "gD", fzf_lsp("declarations"), buf_opts)
  keymap(
    "n",
    "gd",
    fzf_lsp("definitions"),
    vim.tbl_extend("force", buf_opts, { desc = "go to definition" })
  )
  keymap("n", "gr", fzf_lsp("references"), buf_opts)
  keymap("n", "ga", fzf_lsp("code_actions"), buf_opts)
  keymap("n", "gi", fzf_lsp("implementations"), buf_opts)

  keymap(
    "n",
    "gs",
    fzf_lsp(
      "document_symbols",
      { winopts = fzf_winopts_bottom, current_buffer_only = true }
    ),
    buf_opts
  )

  keymap("n", "<space>", vim.lsp.buf.hover, buf_opts)

  keymap("n", "<C-p>", function()
    vim.diagnostic.goto_prev({ border = "rounded" })
  end, buf_opts)

  keymap("n", "<C-n>", function()
    vim.diagnostic.goto_next({ border = "rounded" })
  end, buf_opts)
end

return M
