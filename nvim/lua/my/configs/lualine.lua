local M = {}

function M.setup()
  local lualine = safe_require("lualine")
  if not lualine then
    return
  end

  local bubbles_config = {
    options = {
      --theme = "gruvbox-flat",
      -- theme = "nord",
      theme = "catppuccin",
      component_separators = "|",
      section_separators = { left = "", right = "" },

      disabled_filetypes = { "NvimTree", "dashboard", "Outline" },
    },
    sections = {
      lualine_a = {
        { "mode", separator = { left = "" }, right_padding = 2 },
      },
      lualine_b = { "filename", "branch" },
      lualine_c = { "fileformat" },
      lualine_x = {},
      lualine_y = { "filetype", "progress" },
      lualine_z = {
        { "location", separator = { right = "" }, left_padding = 2 },
      },
    },
    inactive_sections = {
      lualine_a = { "filename" },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = { "location" },
    },
  }
  --

  local powerlineish_config = {
    options = {
      --theme = "gruvbox-flat",
      theme = "nord",
      --theme = "everblush",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },

      disabled_filetypes = { "NvimTree", "dashboard", "Outline" },
    },
    sections = {
      lualine_a = {
        { "mode", separator = { left = "", right = "" }, right_padding = 2 },
      },
      lualine_b = { "branch", "diff" },
      lualine_c = { "filename" },
      lualine_x = { "filetype" },
      lualine_y = { "progress" },
      lualine_z = {
        { "location", separator = { left = "", right = "" }, left_padding = 2 },
      },
    },
    inactive_sections = {
      lualine_a = { "filename" },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = { "location" },
    },
  }

  local config = {
    options = {
      --theme = "gruvbox-flat",
      theme = "nord",

      disabled_filetypes = { "NvimTree", "dashboard", "Outline" },
      component_separators = "",
      section_separators = "",
    },
  }

  lualine.setup(powerlineish_config)
end

return M
