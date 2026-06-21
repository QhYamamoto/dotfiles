local M = {}

local state = {
  last_edit_win = nil,
}

local excluded_filetypes = {
  NvimTree = true,
  codex = true,
}

local function is_valid_win(win)
  return win and vim.api.nvim_win_is_valid(win)
end

local function is_edit_window(win)
  if not is_valid_win(win) or vim.api.nvim_win_get_config(win).relative ~= "" then
    return false
  end

  local buf = vim.api.nvim_win_get_buf(win)
  if vim.api.nvim_get_option_value("buftype", { buf = buf }) ~= "" then
    return false
  end

  local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
  return not excluded_filetypes[filetype]
end

local function fallback_edit_window()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if is_edit_window(win) then
      return win
    end
  end
end

local function close_lazygit_float(win)
  if not is_valid_win(win) then
    return
  end

  if vim.api.nvim_win_get_config(win).relative == "" then
    return
  end

  local buf = vim.api.nvim_win_get_buf(win)
  if vim.api.nvim_get_option_value("buftype", { buf = buf }) == "terminal" then
    vim.api.nvim_win_close(win, true)
  end
end

function M.remember_edit_window()
  local win = vim.api.nvim_get_current_win()
  if is_edit_window(win) then
    state.last_edit_win = win
  end
end

function M.select_edit_window()
  local current_win = vim.api.nvim_get_current_win()
  local win = is_edit_window(state.last_edit_win) and state.last_edit_win or fallback_edit_window()
  if win then
    vim.api.nvim_set_current_win(win)
  end

  close_lazygit_float(current_win)
end

return M
