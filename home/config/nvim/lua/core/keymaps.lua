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
keymap.set({ "n", "i" }, "<C-s>", "<CMD>silent! w<CR>", { desc = "Store" })
keymap.set({ "n", "i", "v" }, "<C-z>", "<CMD>silent! u<CR>", { desc = "Undo" })
keymap.set({ "n", "i", "v" }, "<C-y>", "<CMD>silent! redo<CR>", { desc = "Redo" })
keymap.set({ "n", "i", "v" }, "<C-w>", "<CMD>bd!<CR>", { desc = "Delete current buffer" })
keymap.set("n", "<S-Left>", "<C-W><", { noremap = true, silent = true, desc = "Expand window to the left" })
keymap.set("n", "<S-Right>", "<C-W>>", { noremap = true, silent = true, desc = "Expand window to the right" })
keymap.set("n", "<S-Up>", "<C-W>-", { noremap = true, silent = true, desc = "Expand window to top" })
keymap.set("n", "<S-Down>", "<C-W>+", { noremap = true, silent = true, desc = "Expand window to bottom" })
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

--------------------------------------------------
-- convert surrounding chars command
--------------------------------------------------
_G.SURROUNDING_CHARS_TABLE = {
  ["("] = { "(", ")" },
  ["["] = { "[", "]" },
  ["{"] = { "{", "}" },
  ["<"] = { "<", ">" },
  ['"'] = { '"', '"' },
  ["'"] = { "'", "'" },
  ["`"] = { "`", "`" },
  ["H"] = { "HTML", "HTML" },
  ["S"] = { "SQL", "SQL" },
}

---Convert first match of `original` in `str` to `target`
---@param str string
---@param original string
---@param target string
---@return string
local gsub_first = function(str, original, target)
  local converted_string, _ = str:gsub("^" .. escape_pattern(original), escape_pattern(target), 1)
  return converted_string
end

---Convert last match of `original` in `str` to `target`
---@param str string
---@param original string
---@param target string
---@return string
local gsub_last = function(str, original, target)
  local converted_string, _ = str:gsub("(.*)" .. escape_pattern(original), "%1" .. escape_pattern(target))
  return converted_string
end

function _G.convert_surrounding_chars(opening_char, closing_char)
  local start_pos = vim.fn.getpos "'<" -- start position of visual selection
  local end_pos = vim.fn.getpos "'>" -- end position of visual selection

  local start_line_number = start_pos[2]
  local start_col_number = start_pos[3]
  local end_line_number = end_pos[2]
  local end_col_number = end_pos[3]

  ---@type string[]
  local lines = vim.fn.getline(start_line_number, end_line_number) -- selected lines

  -- detect original surrounding characters
  local opening_original_char = ""
  local closing_original_char = ""
  local first_line_selected_str = lines[1]:sub(start_col_number)
  foreach(SURROUNDING_CHARS_TABLE, function(chars, _)
    if first_line_selected_str ~= gsub_first(first_line_selected_str, chars[1], opening_char) then
      opening_original_char = chars[1]
      closing_original_char = chars[2]
    end
  end)

  -- if original chars aren't detected, then return
  if opening_original_char == "" or closing_original_char == "" then
    return
  end

  ---Function to convert line with opening/closing surrounding char
  ---@param line string
  ---@param i integer
  local convert_line = function(line, i)
    local current_line_number = start_line_number + i - 1

    local setline = function(text)
      vim.fn.setline(current_line_number, text)
    end

    -- if selection start and selection end are in the same line
    if start_line_number == end_line_number then
      local selected_str = line:sub(start_col_number, end_col_number)
      local converted_str = gsub_first(selected_str, opening_original_char, opening_char)
      converted_str = gsub_last(converted_str, closing_original_char, closing_char)

      setline(table.concat {
        line:sub(1, start_col_number - 1),
        converted_str,
        line:sub(end_col_number + 1),
      })
      -- else, convert start line
    elseif current_line_number == start_line_number then
      local selected_str = line:sub(start_col_number)
      local converted_str = gsub_first(selected_str, opening_original_char, opening_char)

      setline(table.concat {
        line:sub(1, start_col_number - 1),
        converted_str,
      })
      -- and then, convert end line
    elseif current_line_number == end_line_number then
      local selected_str = line:sub(1, end_col_number)
      local converted_str = gsub_last(selected_str, closing_original_char, closing_char)

      setline(table.concat {
        converted_str,
        line:sub(end_col_number + 1),
      })
    end
  end

  iforeach(lines, convert_line)
end

function _G.convert_surrounding_chars_with_free_input()
  local opening_char = vim.fn.input "Enter opening char(s): "
  local closing_char = vim.fn.input "Enter closing char(s): "
  convert_surrounding_chars(opening_char, closing_char)
end

foreach(SURROUNDING_CHARS_TABLE, function(chars, key)
  local opening_char = chars[1]
  local closing_char = chars[2]
  keymap.set(
    "v",
    "ys" .. key,
    ":lua convert_surrounding_chars([==[" .. opening_char .. "]==], [==[" .. closing_char .. "]==])<CR>",
    {
      desc = "convert surrounding characters to: " .. opening_char .. closing_char,
      noremap = true,
      silent = true,
    }
  )
end)

keymap.set("v", "ysi", ":lua convert_surrounding_chars_with_free_input()<CR>", {
  desc = "convert surrounding characters to chars specified by free input",
  noremap = true,
  silent = true,
})

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
