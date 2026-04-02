local M = {}

local state = {
  buf = nil,
  win = nil,
  job = nil,
  kind = nil,
}

local config = {
  keymaps = {
    quit = "<C-q>",
  },
  width = 0.8,
  panel = true,
}

local function is_valid_buf(buf)
  return type(buf) == "number" and vim.api.nvim_buf_is_valid(buf)
end

local function is_valid_win(win)
  return type(win) == "number" and vim.api.nvim_win_is_valid(win)
end

local function create_buf()
  local buf = vim.api.nvim_create_buf(false, false)

  vim.api.nvim_set_option_value("bufhidden", "hide", { buf = buf })
  vim.api.nvim_set_option_value("swapfile", false, { buf = buf })
  vim.api.nvim_set_option_value("filetype", "codex", { buf = buf })

  if config.keymaps.quit then
    local quit_cmd = [[<cmd>lua require("core.codex_resume").close()<CR>]]
    vim.keymap.set("t", config.keymaps.quit, [[<C-\><C-n>]] .. quit_cmd, {
      buffer = buf,
      noremap = true,
      silent = true,
      desc = "Hide Codex resume window",
    })
    vim.keymap.set("n", config.keymaps.quit, quit_cmd, {
      buffer = buf,
      noremap = true,
      silent = true,
      desc = "Hide Codex resume window",
    })
  end

  return buf
end

local function open_panel()
  vim.cmd "vertical rightbelow vsplit"
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, state.buf)
  vim.api.nvim_win_set_width(win, math.floor(vim.o.columns * config.width))
  state.win = win
end

local function stop_job()
  if state.job then
    vim.fn.jobstop(state.job)
    state.job = nil
  end
end

local function reset_buffer()
  if is_valid_buf(state.buf) then
    vim.api.nvim_buf_delete(state.buf, { force = true })
  end
  state.buf = nil
end

local function start(cmd, kind)
  if is_valid_win(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end
  state.win = nil

  if state.job and state.kind ~= kind then
    stop_job()
    reset_buffer()
  end

  if state.job and is_valid_buf(state.buf) then
    open_panel()
    return
  end

  if not is_valid_buf(state.buf) then
    state.buf = create_buf()
  end

  open_panel()

  state.kind = kind
  state.job = vim.fn.termopen(cmd, {
    cwd = vim.loop.cwd(),
    on_exit = function()
      state.job = nil
    end,
  })
end

function M.close()
  if is_valid_win(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end
  state.win = nil
end

function M.resume_picker()
  start({ "codex", "resume" }, "resume_picker")
end

function M.resume_last()
  start({ "codex", "resume", "--last" }, "resume_last")
end

return M
