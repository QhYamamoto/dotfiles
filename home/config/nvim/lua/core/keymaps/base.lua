vim.g.mapleader = " "
vim.o.mouse = "a"

local keymap = vim.keymap

keymap.set({ "i", "c" }, "jk", "<ESC>", { desc = "Exit insert mode with jk" })
keymap.set({ "i", "c" }, "ｊｋ", "<ESC>", { desc = "Exit insert mode with ｊｋ" })
keymap.set("n", "い", "i", { desc = "Enter insert mode with い" })
keymap.set("i", "<C-v>", "<ESC>pa", { desc = "Paste." })
keymap.set({ "n", "v" }, "d", '"_d', { desc = "Yank on delete" })
keymap.set("n", "<C-c>", "<C-w>w", { noremap = true, silent = true, desc = "Jump to floating window" })
keymap.set("n", "<M-f>", "w", { noremap = true, silent = true, desc = "Move to next word" })
keymap.set("n", "<M-Right>", "<C-I>", { noremap = true, silent = true, desc = "Jump to newer position" })
keymap.set("n", "<M-Left>", "<C-o>", { noremap = true, silent = true, desc = "Jump to older position" })
keymap.set({ "n", "i" }, "<C-s>", "<CMD>silent! w<CR>", { desc = "Store" })
keymap.set({ "n", "i", "v" }, "<C-z>", "<CMD>silent! u<CR>", { desc = "Undo" })
keymap.set({ "n", "i", "v" }, "<C-y>", "<CMD>silent! redo<CR>", { desc = "Redo" })
keymap.set({ "n", "i", "v" }, "<C-w>", "<CMD>bd!<CR>", { desc = "Delete current buffer" })
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
  -- if search register is not nil, then execute nohl command
  if vim.fn.getreg "/" ~= "" then
    vim.fn.setreg("/", "")
    vim.cmd "nohl"
    return
  end

  -- if focused window is floating one
  local winid = vim.api.nvim_get_current_win()
  if vim.api.nvim_win_get_config(winid).relative ~= "" then
    vim.api.nvim_win_close(winid, true)
    return
  end

  -- Check if the current buffer is a Diffview buffer
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname:match "diffview:" then
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
keymap.set("n", "<LEADER>yf", function()
  vim.fn.setreg("+", vim.fn.expand "%:p")
  print "Filepath has been copied to your clipboard!!"
end, { noremap = true, silent = true, desc = "Save fullpath to currently opened file in a buffer" })
keymap.set("n", "<LEADER>yb", function()
  vim.fn.setreg("+", vim.fn.expand "%:t")
  print "File basename has been copied to your clipboard!!"
end, { noremap = true, silent = true, desc = "Save basename of currently opened file in a buffer" })
keymap.set("n", "<LEADER>yn", function()
  vim.fn.setreg("+", vim.fn.expand "%:t:r")
  print "File basename without extension has been copied to your clipboard!!"
end, { noremap = true, silent = true, desc = "Copy basename without extension of currently opened file" })

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

--------------------------------------------------
-- Insert sequential numbers command
--------------------------------------------------
vim.api.nvim_create_user_command("InsertNumbers", function()
  local start = tonumber(vim.fn.input "Enter start value (default: 1): ") or 1
  local step = tonumber(vim.fn.input "Enter step value (default: 1): ") or 1
  local format = vim.fn.input "Enter format (default: %d): "
  format = format ~= "" and format or "%d" -- because `vim.fn.input` never returns nil

  local start_pos = vim.fn.getpos "v"
  local end_pos = vim.fn.getpos "."
  local start_row = start_pos[2]
  local start_col = start_pos[3]
  local end_row = end_pos[2]

  -- 現在のバッファを取得
  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)

  -- 選択範囲のカラムに連番を挿入
  local number = start
  for i, line in ipairs(lines) do
    local left_part = line:sub(1, start_col - 1)
    local right_part = line:sub(start_col)
    lines[i] = left_part .. string.format(format, number) .. right_part
    number = number + step
  end

  vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, lines)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end, {
  range = true,
  desc = "Insert sequential numbers into the selected block",
})

vim.keymap.set(
  "v",
  "<LEADER>ns",
  "<CMD>InsertNumbers<CR>",
  { desc = "Insert sequential numbers into the selected block" }
)

--------------------------------------------------
-- make numbers on selected lines sequential
--------------------------------------------------
vim.api.nvim_create_user_command("MakeNumbersOnSelectedLinesSequential", function()
  local start_pos = vim.fn.getpos "v"
  local end_pos = vim.fn.getpos "."
  local start_row = start_pos[2]
  local end_row = end_pos[2]

  local first_line = vim.fn.getline(start_row)

  local start = tonumber(string.match(first_line, "%d+")) or 1
  local step = tonumber(vim.fn.input "Enter step value (default: 1): ") or 1

  local current_number = start
  for row = start_row, end_row do
    local line = vim.fn.getline(row)
    local updated_line = string.gsub(line, "%d+", tostring(current_number))
    vim.fn.setline(row, updated_line)
    current_number = current_number + step
  end
end, { range = true })

vim.keymap.set(
  "v",
  "<leader>nr",
  "<CMD>MakeNumbersOnSelectedLinesSequential<CR>",
  { desc = "Make numbers on selected lines sequential" }
)
