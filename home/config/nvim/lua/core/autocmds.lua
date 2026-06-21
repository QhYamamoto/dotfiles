-- register autocmds
vim.api.nvim_create_augroup("lua", {})

vim.api.nvim_create_autocmd({
  "InsertLeave",
  "CmdlineLeave",
}, {
  group = "lua",
  callback = function()
    local home = os.getenv "HOME"
    local script_path = home .. "/.zenhan.zsh"

    local uv = vim.loop
    uv.spawn("zsh", {
      args = { script_path },
      stdio = { nil, nil, nil },
    })
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = "lua",
  pattern = "*.tmpl",
  callback = function()
    vim.bo.filetype = "terraform"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = "lua",
  pattern = "codex",
  callback = function(event)
    require("core.codex_panel").unlist(event.buf)
  end,
})

vim.api.nvim_create_autocmd({
  "BufWinEnter",
  "SessionLoadPost",
  "TermOpen",
  "WinEnter",
}, {
  group = "lua",
  callback = function()
    vim.schedule(function()
      local codex_panel = require "core.codex_panel"
      codex_panel.normalize_buffers()
      codex_panel.restore_focus_mode()
    end)
  end,
})

local function apply_terminal_line_numbers()
  if vim.bo.buftype ~= "terminal" then
    return
  end

  local show_numbers = not vim.b.tui_tool_terminal
  vim.wo.number = show_numbers
  vim.wo.relativenumber = show_numbers
end

vim.api.nvim_create_autocmd({
  "BufWinEnter",
  "TermOpen",
  "WinEnter",
}, {
  group = "lua",
  callback = function()
    vim.schedule(apply_terminal_line_numbers)
  end,
})

vim.api.nvim_create_autocmd({
  "BufWinEnter",
  "WinEnter",
}, {
  group = "lua",
  callback = function()
    require("core.lazygit").remember_edit_window()
  end,
})

local fixed_width_filetypes = {
  codex = 0.4,
  NvimTree = 0.3,
}

local function resize_fixed_width_windows()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
    local width_ratio = fixed_width_filetypes[filetype]

    if width_ratio and vim.api.nvim_win_get_config(win).relative == "" then
      local width = math.floor(vim.o.columns * width_ratio)

      if vim.api.nvim_win_get_width(win) ~= width then
        vim.api.nvim_win_set_width(win, width)
      end
    end
  end
end

vim.api.nvim_create_autocmd({
  "BufWinEnter",
  "WinEnter",
  "WinNew",
  "WinResized",
}, {
  group = "lua",
  callback = function()
    vim.schedule(resize_fixed_width_windows)
  end,
})
