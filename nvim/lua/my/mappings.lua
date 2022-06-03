local M = {}

local map = require("my.utils").map
local nmap = map.nmap
local imap = map.imap
local vmap = map.vmap
local bmap = map.bmap

-- Remap ^c to be the same as escape without telling us to use :q to quit. the
-- 'r' command is special cased to a NOP.
nmap({ "r<C-c>", "<NOP>" })
nmap({ "<C-c>", "<NOP>" })
nmap({ "<C-c>", "<Esc>" })
imap({ "<C-c>", "<Esc>" })

-- Disable EX mode
bmap({ "Q", "<Nop>" })

-- Window movement
nmap({ "<Tab>", "<C-W><C-w>" })
nmap({ "<S-Tab>", "<C-W><S-W>" })

-- Buffer management
nmap({ "<C-]>", "<cmd>bnext<CR>" })
nmap({ "<C-[>", "<cmd>bprev<CR>" })

-- Do not move cursor when using *
nmap({
  "*",
  "<cmd>let s = winsaveview()<CR>*<cmd>:call winrestview(s)<CR>",
})

-- Quick system copy and paste
nmap({ "<Leader>y", '"+y', {} })
nmap({ "<Leader>Y", '"+Y', {} })
vmap({ "<Leader>y", '"+y', {} })

-- fzf
local fzf = require("fzf-lua")
nmap({ "<Leader><Leader>", fzf.git_files })
nmap({ "<Leader>p", fzf.files })
nmap({ "<Leader>b", fzf.buffers })
nmap({ "<Leader>f", fzf.live_grep_native })
nmap({ "<Leader>r", fzf.command_history })

-- nvim-tree
nmap({ "<Leader>t", "<cmd>NvimTreeFindFileToggle<CR>" })

-- Toggle spelling
nmap({ "<Leader>s", "<cmd>set spell!<CR>" })

-- Git
nmap({ "gb", ":Git blame<cr>" })
nmap({ "gh", ":GBrowse!<cr>" })
vmap({ "gh", ":'<'>GBrowse!<cr>" })

-- Substitute
local sub = require("substitute")
nmap({ "s", sub.operator })
nmap({ "ss", sub.line })
nmap({ "S", sub.eol })

-- Yank filepath into system clipboard
nmap({
  "<Leader>yp",
  ":let @+ = expand('%:p')<CR>:echom 'Path copied to system clipboard'<CR>",
})

-- Clear search
nmap({ "<C-l>", ":nohlsearch<CR>:call clearmatches()<CR>" })

-- Repeat the last execuded macro
nmap({ ",", "@@" })

function M.lsp_mapping(bufnr)
  local fzf_conf = require("my.configs.fzf")

  local function fzf_lsp(name, opts)
    local fn = fzf[string.format("lsp_%s", name)]
    return function()
      fn(opts or { winopts = fzf_conf.winopts_bottom, jump_to_single_result = true })
    end
  end

  -- fzf lsp triggers
  map.nmap({ "gD", fzf_lsp("declarations"), bufnr = bufnr })
  map.nmap({ "gd", fzf_lsp("definitions"), bufnr = bufnr, desc = "go to definition" })
  map.nmap({ "gr", fzf_lsp("references"), bufnr = bufnr })
  map.nmap({ "ga", fzf_lsp("code_actions"), bufnr = bufnr })
  map.nmap({ "gi", fzf_lsp("implementations"), bufnr = bufnr })

  map.nmap({
    "gs",
    fzf_lsp(
      "document_symbols",
      { winopts = fzf_conf.winopts_bottom, current_buffer_only = true }
    ),
    bufnr = bufnr,
  })

  map.nmap({
    "<space>",
    function()
      vim.lsp.buf.hover()
    end,
    bufnr = bufnr,
  })

  map.nmap({
    "<C-p>",
    function()
      vim.diagnostic.goto_prev({ border = "rounded" })
    end,
    bufnr = bufnr,
  })

  map.nmap({
    "<C-n>",
    function()
      vim.diagnostic.goto_next({ border = "rounded" })
    end,
    bufnr = bufnr,
  })
end

return M
