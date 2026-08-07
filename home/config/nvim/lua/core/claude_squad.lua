-- Capture Claude Squad-managed agent sessions from tmux into an ordinary buffer.
-- The tool name is Claude Squad, but this repo configures it to launch Codex by
-- default. Capturing through tmux avoids nested terminal copy issues.

local M = {}

local function list_agent_sessions()
  local out = vim.fn.systemlist { "tmux", "list-sessions", "-F", "#{session_name}" }
  if vim.v.shell_error ~= 0 then
    return nil
  end

  local sessions = {}
  for _, name in ipairs(out) do
    if name:match "^claudesquad_" and not name:match "^claudesquad_term_" then
      table.insert(sessions, name)
    end
  end
  return sessions
end

local function capture_lines(session)
  local lines = vim.fn.systemlist {
    "tmux",
    "capture-pane",
    "-p",
    "-J",
    "-S",
    "-100000",
    "-t",
    session,
  }
  if vim.v.shell_error ~= 0 then
    return nil
  end

  for i, line in ipairs(lines) do
    lines[i] = line:gsub("%s+$", "")
  end
  while #lines > 0 and lines[#lines] == "" do
    table.remove(lines)
  end

  return lines
end

local function buf_name_for(session)
  return "claude-squad://" .. session
end

local function find_buf_by_name(name)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_name(buf) == name then
      return buf
    end
  end
  return nil
end

local open_capture

local function ensure_buf(session, lines)
  local name = buf_name_for(session)
  local buf = find_buf_by_name(name)
  if not buf then
    buf = vim.api.nvim_create_buf(false, true)
    pcall(vim.api.nvim_buf_set_name, buf, name)
  end

  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "hide"
  vim.bo[buf].filetype = "markdown"
  vim.bo[buf].modifiable = false

  vim.keymap.set("n", "R", function()
    open_capture(session)
  end, { buffer = buf, silent = true, desc = "Refresh Claude Squad capture" })

  return buf
end

open_capture = function(session)
  local lines = capture_lines(session)
  if not lines then
    vim.notify("claude-squad: capture-pane failed (" .. session .. ")", vim.log.levels.ERROR)
    return
  end
  if #lines == 0 then
    vim.notify("claude-squad: no captured content (" .. session .. ")", vim.log.levels.WARN)
    return
  end

  local buf = ensure_buf(session, lines)
  local wins = vim.fn.win_findbuf(buf)
  if #wins > 0 then
    vim.api.nvim_set_current_win(wins[1])
  else
    vim.cmd "tabnew"
    vim.api.nvim_win_set_buf(0, buf)
  end
  vim.cmd "normal! G"
end

function M.capture()
  local sessions = list_agent_sessions()
  if not sessions then
    vim.notify("claude-squad: tmux server is unavailable", vim.log.levels.ERROR)
    return
  end
  if #sessions == 0 then
    vim.notify("claude-squad: no agent sessions found", vim.log.levels.WARN)
    return
  end
  if #sessions == 1 then
    open_capture(sessions[1])
    return
  end

  vim.ui.select(sessions, { prompt = "Capture session:" }, function(choice)
    if choice then
      open_capture(choice)
    end
  end)
end

return M
