---@module "lazy"

---@type LazySpec
local P = {
  "folke/todo-comments.nvim",
  event = { "BufReadPost", "BufNewFile" },
  cmd = {
    "TodoFzfLua",
    "TodoLocList",
    "TodoQuickFix",
  },
  keys = {
    {
      "]t",
      function()
        require("todo-comments").jump_next()
      end,
      desc = "Next todo comment",
    },
    {
      "[t",
      function()
        require("todo-comments").jump_prev()
      end,
      desc = "Previous todo comment",
    },
    {
      "<Leader>st",
      "<cmd>TodoFzfLua<CR>",
      desc = "Search todo comments",
    },
    {
      "<Leader>xt",
      "<cmd>TodoQuickFix<CR>",
      desc = "Todo comments to quickfix",
    },
  },
}

P.dependencies = {
  { "nvim-lua/plenary.nvim" },
}

P.opts = {
  search = {
    command = "rg",
  },
  keywords = {
    FIX = {
      icon = " ", -- icon used for the sign, and in search results
      color = "error", -- can be a hex color, or a named color (see below)
      alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
      -- signs = false, -- configure signs for some keywords individually
    },
    TODO = { icon = " ", color = "info" },
    HACK = { icon = " ", color = "warning" },
    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
    PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
    TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
  },
}

return P
