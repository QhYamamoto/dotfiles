return {
  "mattn/vim-maketable",
  config = function()
    local keymap = vim.keymap

    keymap.set("n", "<LEADER>mt", ":MakeTable!<CR>", { noremap = true, silent = true })
    keymap.set("v", "<LEADER>mt", ":'<,'>MakeTable!<CR>", { noremap = true, silent = true })
  end,
}
