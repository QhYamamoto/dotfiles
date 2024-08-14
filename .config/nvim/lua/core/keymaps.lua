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
  { "(", ")" },
  { "[", "]" },
  { "{", "}" },
  { "<", ">" },
  { '"', '"' },
  { "'", "'" },
  { "`", "`" },
}

function _G.convert_sorrounding_chars(char)
  local start_surrounding_char = ""
  local end_surrounding_char = ""
  for _, chars in ipairs(SURROUNDING_CHARS_TABLE) do
    if char == chars[1] then
      start_surrounding_char = chars[1]
      end_surrounding_char = chars[2]
    end
  end

  if start_surrounding_char == "" and end_surrounding_char == "" then
    start_surrounding_char = char
    end_surrounding_char = char
  end

  local start_pos = vim.fn.getpos "'<" -- start position of visual selection
  local end_pos = vim.fn.getpos "'>" -- end position of visual selection

  local start_line_number = start_pos[2]
  local start_col_number = start_pos[3]
  local end_line_number = end_pos[2]
  local end_col_number = end_pos[3]
  local lines = vim.fn.getline(start_line_number, end_line_number) -- selected lines

  -- get selected text
  local line_index = 1
  for line_number = start_line_number, end_line_number do
    local line = lines[line_index]
    local converted_text = nil

    if line ~= nil then
      -- if selection start and selection end are in the same line
      if start_line_number == end_line_number then
        local selected_text = line:sub(start_col_number, end_col_number)
        converted_text = line:sub(1, start_col_number - 1)
          .. start_surrounding_char
          .. selected_text:sub(2, -2)
          .. end_surrounding_char
          .. line:sub(end_col_number + 1)
      -- else, convert start line
      elseif line_number == start_line_number then
        local selected_text = line:sub(start_col_number - 1)
        print(line:sub(1, start_col_number - 1))
        converted_text = line:sub(1, start_col_number - 1) .. start_surrounding_char .. selected_text:sub(3)
      -- and then, convert end line
      elseif line_number == end_line_number then
        local selected_text = line:sub(1, end_col_number - 1)
        converted_text = selected_text:sub(1, -1) .. end_surrounding_char
      end

      if converted_text ~= nil then
        vim.fn.setline(line_number, converted_text)
      end

      line_index = line_index + 1
    end
  end
end

function _G.convert_sorrounding_chars_with_free_input()
  local input = vim.fn.input "Enter surrounding chars: "
  convert_sorrounding_chars(input)
end

for _, chars in ipairs(SURROUNDING_CHARS_TABLE) do
  local start_surrounding_char = chars[1]
  local end_surrounding_char = chars[2]
  keymap.set(
    "v",
    "ys" .. start_surrounding_char,
    ":lua convert_sorrounding_chars([[" .. start_surrounding_char .. "]])<CR>",
    {
      desc = "convert surrounding characters to: " .. start_surrounding_char .. end_surrounding_char,
      noremap = true,
      silent = true,
    }
  )
end

keymap.set("v", "ysi", ":lua convert_sorrounding_chars_with_free_input()<CR>", {
  desc = "convert surrounding characters to chars specified by free input",
  noremap = true,
  silent = true,
})
