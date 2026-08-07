local M = {}

local function cheatsheet_path()
  return vim.fs.normalize(vim.fn.stdpath "config" .. "/cheatsheet.md")
end

local function make_buf(lines)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "markdown"
  return buf
end

function M.open()
  local path = cheatsheet_path()
  local lines
  if vim.fn.filereadable(path) == 1 then
    lines = vim.fn.readfile(path)
  else
    lines = { "# Cheat Sheet", "", "cheatsheet.md not found:", path }
  end

  local buf = make_buf(lines)
  local width = math.min(88, math.max(48, math.floor(vim.o.columns * 0.8)))
  local height = math.max(math.min(#lines, math.floor(vim.o.lines * 0.85)), 1)
  local row = math.max(math.floor((vim.o.lines - height) / 2 - 1), 0)
  local col = math.max(math.floor((vim.o.columns - width) / 2), 0)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " Cheat Sheet ",
    title_pos = "center",
  })
  vim.wo[win].wrap = false
  vim.wo[win].cursorline = true
  vim.wo[win].conceallevel = 2
  vim.wo[win].concealcursor = "n"

  for _, key in ipairs { "q", "<Esc>" } do
    vim.keymap.set("n", key, function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end, { buffer = buf, nowait = true, silent = true, desc = "Close cheat sheet" })
  end
end

return M
