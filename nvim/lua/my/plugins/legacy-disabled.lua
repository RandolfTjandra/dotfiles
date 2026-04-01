---@module "lazy"

---@type LazySpec[]
local P = {
  -- Present in the old packer config but intentionally disabled during the lazy migration.
  { "folke/which-key.nvim", enabled = false },
  { "nvim-lua/plenary.nvim", enabled = false },
  { "styled-components/vim-styled-components", enabled = false },
  { "hrsh7th/cmp-emoji", enabled = false },
  { "b4winckler/vim-angry", enabled = false },
  { "EdenEast/nightfox.nvim", enabled = false },
  { "eddyekofo94/gruvbox-flat.nvim", enabled = false },
  { "mangeshrex/everblush.vim", enabled = false },
}

return P
