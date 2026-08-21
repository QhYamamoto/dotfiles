vim.g.mapleader = " "
vim.o.mouse = "a"

local keymap = vim.keymap

local copy_to_clipboard = function(value, message)
  vim.fn.setreg("+", value)
  print(message)
end

keymap.set({ "i", "c" }, "jk", "<ESC>", { desc = "Exit insert mode with jk" })
keymap.set({ "i", "c" }, "ｊｋ", "<ESC>", { desc = "Exit insert mode with ｊｋ" })
keymap.set("n", "い", "i", { desc = "Enter insert mode with い" })
keymap.set("i", "<C-v>", "<ESC>pa", { desc = "Paste." })
keymap.set({ "n", "v" }, "d", '"_d', { desc = "Yank on delete" })
-- フローティングウィンドウ(LSPホバー等のポップアップ)があればそこへカーソルを移す。
-- 単なる <C-w>w はウィンドウ順送りのため、フローティングを狙っても別ペイン(Claude等)へ
-- 飛ぶことがある。フォーカス可能なフローティングのうち最前面(zindexが最大)のものへ移動し、
-- 無ければ通常のウィンドウ切替に委ねる。複数フロート(定義ホバーと診断等)が並んでも、
-- 今一番手前に見えているポップアップに入れる。
local focus_floating_window = function()
  local target, top_zindex = nil, -1
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" and config.focusable and (config.zindex or 0) > top_zindex then
      target, top_zindex = win, config.zindex or 0
    end
  end
  if target then
    vim.api.nvim_set_current_win(target)
  else
    vim.cmd "wincmd w"
  end
end
keymap.set("n", "<C-c>", focus_floating_window, { noremap = true, silent = true, desc = "Jump to floating window" })
keymap.set("n", "<M-f>", "w", { noremap = true, silent = true, desc = "Move to next word" })
keymap.set("n", "<M-Right>", "<C-I>", { noremap = true, silent = true, desc = "Jump to newer position" })
keymap.set("n", "<M-Left>", "<C-o>", { noremap = true, silent = true, desc = "Jump to older position" })
keymap.set({ "n", "i" }, "<C-s>", "<CMD>silent! w<CR>", { desc = "Store" })
keymap.set({ "n", "i", "v" }, "<C-z>", "<CMD>silent! u<CR>", { desc = "Undo" })
keymap.set({ "n", "i", "v" }, "<C-y>", "<CMD>silent! redo<CR>", { desc = "Redo" })
-- 素の :bdelete は、そのバッファを表示していたウィンドウも一緒に閉じてしまう。分割
-- レイアウトを保ったままバッファだけを破棄したいので、対象を映しているウィンドウを先に
-- 別のバッファへ差し替えてから削除する。差し替え先はそのウィンドウの直前のバッファを
-- 優先し、無ければバッファ番号順で次(末尾なら手前)のものを使う。他に何も残らない場合は
-- 空バッファを作ってウィンドウを埋める。フローティングは差し替えず削除時に閉じさせる。
local delete_current_buffer = function()
  local target = vim.api.nvim_get_current_buf()

  local listed = vim.tbl_filter(function(buf)
    return buf ~= target and vim.bo[buf].buflisted
  end, vim.api.nvim_list_bufs())

  local usable = function(buf)
    return buf ~= nil and buf > 0 and buf ~= target and vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted
  end

  local shared = nil
  local fallback = function()
    if usable(shared) then
      return shared
    end
    for _, buf in ipairs(listed) do
      if buf > target then
        shared = buf
        break
      end
    end
    shared = shared or listed[#listed] or vim.api.nvim_create_buf(true, false)
    return shared
  end

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local is_floating = vim.api.nvim_win_get_config(win).relative ~= ""
    if not is_floating and vim.api.nvim_win_get_buf(win) == target then
      local alt = vim.api.nvim_win_call(win, function()
        return vim.fn.bufnr "#"
      end)
      vim.api.nvim_win_set_buf(win, usable(alt) and alt or fallback())
    end
  end

  pcall(vim.api.nvim_buf_delete, target, { force = true })
end
keymap.set({ "n", "i", "v" }, "<C-w>", delete_current_buffer, { desc = "Delete current buffer, keeping the window" })
keymap.set("n", "<M-S-Left>", "<C-W><", { noremap = true, silent = true, desc = "Expand window to the left" })
keymap.set("n", "<M-S-Right>", "<C-W>>", { noremap = true, silent = true, desc = "Expand window to the right" })
keymap.set("n", "<M-S-Up>", "<C-W>-", { noremap = true, silent = true, desc = "Expand window to top" })
keymap.set("n", "<M-S-Down>", "<C-W>+", { noremap = true, silent = true, desc = "Expand window to bottom" })
keymap.set("n", "<tab>", "<CMD>><CR>", { desc = "Incriment indent level" })
keymap.set("n", "<S-Tab>", "<CMD><<CR>", { desc = "Decriment indent level" })
keymap.set("n", "<A-Down>", '"xdd"xp<CMD>Format<CR>', { desc = "Swap current line with line below" })
keymap.set("i", "<A-Down>", '<ESC>"xdd"xpi<CMD>Format<CR>', { desc = "Swap current line with line below" })
keymap.set({ "n", "i" }, "<A-Up>", '<Up>"xdd"xp<Up><CMD>Format<CR>', { desc = "Swap current line with line above" })
keymap.set("i", "<A-Up>", '<ESC><Up>"xdd"xp<Up>i<CMD>Format<CR>', { desc = "Swap current line with line above" })
keymap.set("n", "<C-a>", "gg^vG$", { desc = "Select whole text" })
keymap.set("n", "<C-e>", "$", { noremap = true, silent = true, desc = "Move cursor to the end of the line" })
keymap.set("i", "<C-e>", "<ESC>$a", { noremap = true, silent = true, desc = "Move cursor to the end of the line" })
keymap.set("t", "jk", "<C-\\><C-n>", { noremap = true, silent = true, desc = "Focus out from the terminal" })
keymap.set("n", "cc", "yydd", { noremap = true, silent = true, desc = "Cut and delete line" })
keymap.set("n", ",m", "<CMD>silent! %s/\\r//g<CR>", { desc = "Remove all \\r characters in buffer" })
keymap.set("n", "<ESC>", function()
  -- Prefer clearing transient UI state before falling back to a plain <Esc>.
  if vim.fn.getreg "/" ~= "" then
    vim.fn.setreg("/", "")
    vim.cmd "nohl"
    return
  end

  local winid = vim.api.nvim_get_current_win()
  if vim.api.nvim_win_get_config(winid).relative ~= "" then
    vim.api.nvim_win_close(winid, true)
    return
  end

  if vim.api.nvim_buf_get_name(0):match "diffview:" then
    vim.cmd "DiffviewClose"
    return
  end

  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "n", true)
end)
keymap.set("n", "J", function()
  local concatenateNextLintToCurrentLine = function()
    local current_line = vim.api.nvim_get_current_line()
    local current_line_number = vim.fn.line "."
    local next_line = vim.api.nvim_buf_get_lines(0, current_line_number, current_line_number + 1, false)[1]
    if next_line then
      local next_line_trimmed = next_line:gsub("^%s+", "")
      vim.api.nvim_set_current_line(current_line .. next_line_trimmed)
      vim.api.nvim_buf_set_lines(0, current_line_number, current_line_number + 1, false, {})
    end
  end

  local count = vim.v.count
  if count == 0 then
    count = 1
  end

  for _ = 1, count do
    concatenateNextLintToCurrentLine()
  end
end, { noremap = true, silent = true, desc = "Concatenate next lint to current line" })

keymap.set("n", "<LEADER>q", "<CMD>qa<CR>", { desc = "Quit neovim" })
keymap.set("n", "<LEADER>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<LEADER>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<LEADER>sx", "<CMD>close<CR>", { desc = "Close current split" })
keymap.set("n", "<LEADER>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<LEADER>bp", "<CMD>bprev<CR>", { desc = "Jump to previous buffer" })
keymap.set("n", "<LEADER>za", "za", { remap = true, desc = "Toggle fold under cursor" })
keymap.set("n", "<LEADER>zo", "zo", { remap = true, desc = "Open fold under cursor" })
keymap.set("n", "<LEADER>zc", "zc", { remap = true, desc = "Close fold under cursor" })
keymap.set("n", "<LEADER>zR", "zR", { remap = true, desc = "Open all folds" })
keymap.set("n", "<LEADER>zM", "zM", { remap = true, desc = "Close all folds" })
keymap.set("n", "<LEADER>yf", function()
  copy_to_clipboard(vim.fn.expand "%:p", "Filepath has been copied to your clipboard!!")
end, { noremap = true, silent = true, desc = "Save fullpath to currently opened file in a buffer" })
keymap.set("n", "<LEADER>yb", function()
  copy_to_clipboard(vim.fn.expand "%:t", "File basename has been copied to your clipboard!!")
end, { noremap = true, silent = true, desc = "Save basename of currently opened file in a buffer" })
keymap.set("n", "<LEADER>yn", function()
  copy_to_clipboard(vim.fn.expand "%:t:r", "File basename without extension has been copied to your clipboard!!")
end, { noremap = true, silent = true, desc = "Copy basename without extension of currently opened file" })
keymap.set("n", "<LEADER>yr", function()
  -- %:. はカレントディレクトリ(Neovimを開いたディレクトリ)を基準にした相対パス。
  -- カレント配下にないファイルはそのまま絶対パスになる。
  copy_to_clipboard(vim.fn.expand "%:.", "Relative filepath has been copied to your clipboard!!")
end, { noremap = true, silent = true, desc = "Copy filepath relative to the current directory (project root)" })
keymap.set({ "n", "x" }, "<LEADER>yl", function()
  -- 相対パス + 行番号(レビューやログ参照の定番形式)。ビジュアルモードでは選択した
  -- 行範囲を付ける(例 src/foo.ts:42-48)。単一行や通常モードは1行だけ(:42)。
  local rel = vim.fn.expand "%:."
  local mode = vim.fn.mode()
  local ref
  if mode == "v" or mode == "V" or mode == "\22" then
    local a, b = vim.fn.line "v", vim.fn.line "."
    if a > b then
      a, b = b, a
    end
    ref = a == b and (rel .. ":" .. a) or (rel .. ":" .. a .. "-" .. b)
  else
    ref = rel .. ":" .. vim.fn.line "."
  end
  copy_to_clipboard(ref, "Relative filepath with line has been copied to your clipboard!!")
end, { noremap = true, silent = true, desc = "Copy relative filepath with line number (range in visual)" })
keymap.set("n", "<LEADER>yd", function()
  -- %:.:h はカレント基準の相対パスの親ディレクトリ。直下のファイルでは "." になる。
  copy_to_clipboard(vim.fn.expand "%:.:h", "Directory of current file has been copied to your clipboard!!")
end, { noremap = true, silent = true, desc = "Copy directory of current file (relative)" })
keymap.set("n", "<LEADER>yG", function()
  -- gitルート(.gitを持つ最も近い祖先)基準の相対パス。cwd基準の<LEADER>yrと違い、
  -- cwd≠gitルートでも常にリポジトリルートからの相対になる。
  local root = vim.fs.root(0, ".git")
  local file = vim.fn.expand "%:p"
  if root and file:sub(1, #root) == root then
    copy_to_clipboard(file:sub(#root + 2), "Git-root-relative filepath has been copied to your clipboard!!")
  else
    -- git管理外: gitルートが無いのでcwd相対(cwdの外なら絶対)にフォールバックする。
    -- コピー内容と表示が食い違わないよう、フォールバックした旨を明示する。
    vim.fn.setreg("+", vim.fn.expand "%:.")
    vim.notify("Not in a git repo — copied cwd-relative path instead.", vim.log.levels.WARN)
  end
end, { noremap = true, silent = true, desc = "Copy filepath relative to the git root" })

-- 自分用チートシート(cheatsheet.md)をフローティングウィンドウで開く。
keymap.set("n", "<LEADER>?", function()
  require("core.cheatsheet").open()
end, { noremap = true, silent = true, desc = "Open personal cheat sheet" })
vim.api.nvim_create_user_command("Cheatsheet", function()
  require("core.cheatsheet").open()
end, { desc = "Open the personal cheat sheet in a floating window" })

local jump_to_closest_parentheses = function(direction)
  local flags = direction == "backward" and "bW" or "W"
  local row, col = unpack(vim.fn.searchpos("[()\\[\\]{}]", flags))
  if row > 0 then
    vim.api.nvim_win_set_cursor(0, { row, col - 1 })
  end
end

vim.keymap.set({ "n", "v" }, "<C-p>", function()
  jump_to_closest_parentheses "forward"
end, { noremap = true, silent = true })

vim.keymap.set({ "n", "v" }, "<C-M-P>", function()
  jump_to_closest_parentheses "backward"
end, { noremap = true, silent = true })

vim.keymap.set(
  "v",
  "<LEADER>ns",
  "<CMD>InsertNumbers<CR>",
  { desc = "Insert sequential numbers into the selected block" }
)

vim.keymap.set(
  "v",
  "<leader>nr",
  "<CMD>MakeNumbersOnSelectedLinesSequential<CR>",
  { desc = "Make numbers on selected lines sequential" }
)
