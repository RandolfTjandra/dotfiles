local M = {}

-- Updates a highlight group.
function M.update_hl(group, rules)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, create = false })
  if not ok then
    vim.notify(string.format("Highlight group '%s' not found", group), vim.log.levels.WARN)
    return
  end

  local merged = vim.tbl_extend("force", hl, rules)
  vim.api.nvim_set_hl(0, group, merged)
end

return M
