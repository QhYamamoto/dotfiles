vim.g.mapleader = " "
vim.o.mouse = 'a'

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
keymap.set("n", "<LEADER>nh", ":nohl<CR>", { desc = "Clear search highlights" })
keymap.set({ "n", "v" }, "d", '"_d')                                  -- prevent to yank on delete
keymap.set("n", "<C-c>", "<C-w>w", { noremap = true, silent = true }) -- jump to floating window
keymap.set("n", "<LEADER>q", "<CMD>qa<CR>")
keymap.set("n", "<M-u>", "<C-a>", { noremap = true, silent = true })
keymap.set("n", "<M-d>", "<C-x>", { noremap = true, silent = true })

-- window
keymap.set("n", "<LEADER>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<LEADER>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<LEADER>sx", "<CMD>close<CR>", { desc = "Close current split" })
keymap.set("n", "<LEADER>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<S-Left>", '<C-W><', { noremap = true, silent = true })
keymap.set("n", "<S-Right>", '<C-W>>', { noremap = true, silent = true })
keymap.set("n", "<S-Up>", '<C-W>-', { noremap = true, silent = true })
keymap.set("n", "<S-Down>", '<C-W>+', { noremap = true, silent = true })

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

keymap.set("n", "J", function()
    repeat_func(function()
      local current_line = vim.api.nvim_get_current_line()
      local next_line = vim.api.nvim_buf_get_lines(0, vim.fn.line(".") + 1 - 1, vim.fn.line(".") + 2 - 1, false)[1]
      if next_line then
        local next_line_trimmed = next_line:gsub("^%s+", "")
        vim.api.nvim_set_current_line(current_line .. next_line_trimmed)
        vim.api.nvim_buf_set_lines(0, vim.fn.line(".") + 1 - 1, vim.fn.line(".") + 1, false, {})
      end
    end, vim.v.count or 1
    )
  end,
  { noremap = true, silent = true }
)
