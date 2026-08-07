-- 自分用チートシートを、Neovim のフローティングウィンドウに表示するモジュール。
-- 内容は stdpath("config")/cheatsheet.md(= ~/.config/nvim/cheatsheet.md、リポジトリ内)
-- を読むだけなので、キーバインド一覧の追記・編集はその markdown を直接いじればよい。
-- 表示は読み取り専用のスクラッチバッファで、q / <Esc> で閉じる。

local M = {}

local function cheatsheet_path()
  return vim.fs.normalize(vim.fn.stdpath "config" .. "/cheatsheet.md")
end

-- 表示用のスクラッチバッファを用意する。読み取り専用・markdownとして扱う。
local function make_buf(lines)
  local buf = vim.api.nvim_create_buf(false, true) -- unlisted scratch
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
    lines = { "# Cheat Sheet", "", "cheatsheet.md が見つかりません:", path }
  end

  local buf = make_buf(lines)

  -- エディタ中央に、内容量と画面サイズに応じたサイズで開く。
  local width = math.min(88, math.max(48, math.floor(vim.o.columns * 0.8)))
  local height = math.min(#lines, math.floor(vim.o.lines * 0.85))
  height = math.max(height, 1)
  local row = math.floor((vim.o.lines - height) / 2 - 1)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.max(row, 0),
    col = math.max(col, 0),
    style = "minimal",
    border = "rounded",
    title = " Cheat Sheet (q で閉じる) ",
    title_pos = "center",
  })
  vim.wo[win].wrap = false
  vim.wo[win].cursorline = true
  vim.wo[win].conceallevel = 2
  vim.wo[win].concealcursor = "n"

  -- q / <Esc> で閉じる(このバッファ限定)。
  for _, key in ipairs { "q", "<Esc>" } do
    vim.keymap.set("n", key, function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end, { buffer = buf, nowait = true, silent = true, desc = "Close cheat sheet" })
  end
end

return M
