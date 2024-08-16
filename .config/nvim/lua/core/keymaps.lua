vim.g.mapleader = " "
vim.o.mouse = "a"

local keymap = vim.keymap

-- function for repeat function
local function repeat_func(func, count)
  if count == 0 then
    func()
    return
  end
  for _ = 1, count do
    func()
  end
end

-- general
keymap.set({ "i", "c" }, "jk", "<ESC>", { desc = "Exit insert mode with jk" })
keymap.set({ "i", "c" }, "ｊｋ", "<ESC>", { desc = "Exit insert mode with ｊｋ" })
keymap.set("n", "い", "i", { desc = "Enter insert mode with い" })
keymap.set("i", "<C-v>", "<ESC>pa", { desc = "Paste." })
keymap.set("n", "<ESC>", function()
  -- if search register is not nil, then execute nohl command
  if vim.fn.getreg "/" then
    vim.cmd "nohl"
  else
    vim.cmd "normal! <ESC>"
  end
end, { desc = "Clear search highlights" })
keymap.set({ "n", "v" }, "d", '"_d') -- prevent to yank on delete
keymap.set("n", "<C-c>", "<C-w>w", { noremap = true, silent = true }) -- jump to floating window
keymap.set("n", "<LEADER>q", "<CMD>qa<CR>")
keymap.set("n", "<M-u>", "<C-a>", { noremap = true, silent = true })
keymap.set("n", "<M-d>", "<C-x>", { noremap = true, silent = true })
keymap.set("n", "<M-f>", "w", { noremap = true, silent = true })

-- window
keymap.set("n", "<LEADER>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<LEADER>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<LEADER>sx", "<CMD>close<CR>", { desc = "Close current split" })
keymap.set("n", "<LEADER>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<S-Left>", "<C-W><", { noremap = true, silent = true })
keymap.set("n", "<S-Right>", "<C-W>>", { noremap = true, silent = true })
keymap.set("n", "<S-Up>", "<C-W>-", { noremap = true, silent = true })
keymap.set("n", "<S-Down>", "<C-W>+", { noremap = true, silent = true })

-- shortcuts to ensure compatibility with other editors
keymap.set("n", "<LEADER>bp", "<CMD>bprev<CR>", { desc = "Jump to previous buffer" })
keymap.set({ "n", "i" }, "<C-s>", "<CMD>silent! w<CR>", { desc = "Store" })
keymap.set({ "n", "i", "v" }, "<C-z>", "<CMD>silent! u<CR>", { desc = "Undo" })
keymap.set({ "n", "i", "v" }, "<C-y>", "<CMD>silent! redo<CR>", { desc = "Redo" })
keymap.set({ "n", "i", "v" }, "<C-w>", "<CMD>bd!<CR>", { desc = "Delete current buffer" })
keymap.set("n", "<tab>", "<CMD>><CR>", { desc = "Incriment indent level" })
keymap.set({ "n", "i" }, "<S-Tab>", "<CMD><<CR>", { desc = "Decriment indent level" })
keymap.set("n", "<A-Down>", "ddp", { desc = "Swap current line with line below" })
keymap.set("i", "<A-Down>", "<ESC>ddpi", { desc = "Swap current line with line below" })
keymap.set({ "n", "i" }, "<A-Up>", "<Up>ddp<Up>", { desc = "Swap current line with line above" })
keymap.set("i", "<A-Up>", "<ESC><Up>ddp<Up>i", { desc = "Swap current line with line above" })
keymap.set("n", "<C-a>", "gg^vG$", { desc = "Select whole text" })
keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { noremap = true, silent = true, expr = true })
keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { noremap = true, silent = true, expr = true })
keymap.set("n", "<C-e>", "$", { noremap = true, silent = true })
keymap.set("i", "<C-e>", "<ESC>$a", { noremap = true, silent = true })

-- for terminal
keymap.set("t", "jk", "<C-\\><C-n>", { noremap = true })

keymap.set("n", "<leader>y", function()
  vim.fn.setreg("+", vim.fn.expand "%:p")
  print "Filepath's been copied to your clipboard!!"
end, { desc = "save fullpath to currently opend file in a buffer", noremap = true, silent = true })

keymap.set("n", "J", function()
  repeat_func(function()
    local current_line = vim.api.nvim_get_current_line()
    local next_line = vim.api.nvim_buf_get_lines(0, vim.fn.line "." + 1 - 1, vim.fn.line "." + 2 - 1, false)[1]
    if next_line then
      local next_line_trimmed = next_line:gsub("^%s+", "")
      vim.api.nvim_set_current_line(current_line .. next_line_trimmed)
      vim.api.nvim_buf_set_lines(0, vim.fn.line "." + 1 - 1, vim.fn.line "." + 1, false, {})
    end
  end, vim.v.count or 1)
end, { noremap = true, silent = true })

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
