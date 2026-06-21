local M = {}

local config = {
  width = 0.4,
}

local function is_valid_buf(buf)
  return type(buf) == "number" and vim.api.nvim_buf_is_valid(buf)
end

local function is_valid_win(win)
  return type(win) == "number" and vim.api.nvim_win_is_valid(win)
end

local function is_codex_buf(buf)
  return is_valid_buf(buf) and vim.api.nvim_get_option_value("filetype", { buf = buf }) == "codex"
end

local function is_codex_terminal_buf(buf)
  if not is_valid_buf(buf) or vim.api.nvim_get_option_value("buftype", { buf = buf }) ~= "terminal" then
    return false
  end

  local name = vim.api.nvim_buf_get_name(buf)

  return name:match "/bin/codex$"
    or name:match "/bin/codex resume %-%-last$"
    or name:match "/bin/codex\\ resume\\ %-%-last$"
    or name:match "/bin/codex %-%-continue$"
    or name:match "/bin/codex\\ %-%-continue$"
end

local function remember_focus_mode(buf, terminal_focused)
  vim.b[buf].codex_terminal_focused = terminal_focused
end

local function navigate(direction, terminal_focused)
  local buf = vim.api.nvim_get_current_buf()
  remember_focus_mode(buf, terminal_focused)

  if terminal_focused then
    vim.cmd "stopinsert"
  end

  vim.cmd("TmuxNavigate" .. direction)
end

local function set_navigation_keymaps(buf)
  if vim.b[buf].codex_navigation_keymaps_set then
    return
  end

  local maps = {
    { lhs = "<C-h>", direction = "Left", desc = "Move to left pane" },
    { lhs = "<C-k>", direction = "Up", desc = "Move to upper pane" },
    { lhs = "<C-l>", direction = "Right", desc = "Move to right pane" },
  }

  for _, map in ipairs(maps) do
    vim.keymap.set("n", map.lhs, function()
      navigate(map.direction, false)
    end, {
      buffer = buf,
      noremap = true,
      silent = true,
      desc = map.desc,
    })

    vim.keymap.set("t", map.lhs, function()
      navigate(map.direction, true)
    end, {
      buffer = buf,
      noremap = true,
      silent = true,
      desc = map.desc,
    })
  end

  vim.b[buf].codex_navigation_keymaps_set = true
end

local function set_codex_buf_options(buf)
  if is_codex_terminal_buf(buf) and vim.api.nvim_get_option_value("filetype", { buf = buf }) ~= "codex" then
    vim.api.nvim_set_option_value("filetype", "codex", { buf = buf })
  end

  vim.api.nvim_set_option_value("buflisted", false, { buf = buf })
  set_navigation_keymaps(buf)
end

local function is_codex_like_buf(buf)
  return is_codex_buf(buf) or is_codex_terminal_buf(buf)
end

local function codex_windows()
  local wins = {}

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if is_valid_win(win) and vim.api.nvim_win_get_config(win).relative == "" then
      local buf = vim.api.nvim_win_get_buf(win)

      if is_codex_like_buf(buf) then
        table.insert(wins, win)
      end
    end
  end

  return wins
end

local function normal_window_count()
  local count = 0

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if is_valid_win(win) and vim.api.nvim_win_get_config(win).relative == "" then
      count = count + 1
    end
  end

  return count
end

local function codex_buffers()
  local bufs = {}

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if is_codex_like_buf(buf) then
      table.insert(bufs, buf)
    end
  end

  return bufs
end

local function reusable_codex_buf()
  local current_buf = vim.api.nvim_get_current_buf()

  if is_codex_like_buf(current_buf) then
    return current_buf
  end

  local wins = codex_windows()
  if #wins > 0 then
    return vim.api.nvim_win_get_buf(wins[1])
  end

  local bufs = codex_buffers()
  return bufs[1]
end

local function open_panel(buf)
  vim.cmd "vertical rightbelow vsplit"

  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_win_set_width(win, math.floor(vim.o.columns * config.width))
  set_codex_buf_options(buf)
end

function M.hide()
  local normal_count = normal_window_count()

  for _, win in ipairs(codex_windows()) do
    if is_valid_win(win) then
      if normal_count > 1 then
        vim.api.nvim_win_close(win, true)
        normal_count = normal_count - 1
      else
        vim.api.nvim_set_current_win(win)
        vim.cmd "enew"
      end
    end
  end
end

function M.is_visible()
  return #codex_windows() > 0
end

function M.toggle_existing()
  if M.is_visible() then
    M.hide()
    return true
  end

  local buf = reusable_codex_buf()
  if buf then
    open_panel(buf)
    return true
  end

  return false
end

function M.toggle()
  if M.toggle_existing() then
    return
  end

  require("codex").open()
end

function M.unlist(buf)
  if is_codex_like_buf(buf) then
    set_codex_buf_options(buf)
  end
end

function M.normalize_buffers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    M.unlist(buf)
  end
end

function M.restore_focus_mode()
  local buf = vim.api.nvim_get_current_buf()

  if not is_codex_terminal_buf(buf) or not vim.b[buf].codex_terminal_focused then
    return
  end

  vim.schedule(function()
    if vim.api.nvim_get_current_buf() == buf then
      vim.cmd "startinsert"
    end
  end)
end

local function migrate_session_path(path)
  if vim.fn.filereadable(path) == 0 then
    return
  end

  local lines = vim.fn.readfile(path)
  local changed = false

  for index, line in ipairs(lines) do
    local updated = line

    if line:find("/bin/codex\\ --continue", 1, true) then
      updated = line:gsub("/bin/codex\\ %-%-continue", "/bin/codex\\ resume\\ --last")
      changed = true
    elseif line:find("/bin/codex", 1, true) and not line:find("/bin/codex\\ resume\\ --last", 1, true) then
      updated = line:gsub("/bin/codex", "/bin/codex\\ resume\\ --last")
      changed = true
    end

    lines[index] = updated
  end

  if changed then
    vim.fn.writefile(lines, path)
  end
end

function M.migrate_session_file(session_name)
  local auto_session = require "auto-session"
  local auto_session_lib = require "auto-session.lib"
  local root_dir = auto_session.get_root_dir(true)

  migrate_session_path(root_dir .. auto_session_lib.escape_session_name(session_name) .. ".vim")
  migrate_session_path(root_dir .. auto_session_lib.legacy_escape_session_name(session_name) .. ".vim")
end

return M
