return {
  "aaronik/treewalker.nvim",
  config = function()
    local keymap = vim.keymap

    -- movement
    keymap.set({ "n", "v" }, "<LEADER><Up>", "<CMD>Treewalker Up<CR>", { silent = true })
    keymap.set({ "n", "v" }, "<LEADER><Down>", "<CMD>Treewalker Down<CR>", { silent = true })
    keymap.set({ "n", "v" }, "<LEADER><Right>", "<CMD>Treewalker Right<CR>", { silent = true })
    keymap.set({ "n", "v" }, "<LEADER><Left>", "<CMD>Treewalker Left<CR>", { silent = true })

    -- swapping
    keymap.set("n", "<LEADER>K", "<CMD>Treewalker SwapUp<CR>", { silent = true })
    keymap.set("n", "<LEADER>J", "<CMD>Treewalker SwapDown<CR>", { silent = true })
    keymap.set("n", "<LEADER>L", "<CMD>Treewalker SwapRight<CR>", { silent = true })
    keymap.set("n", "<LEADER>H", "<CMD>Treewalker SwapLeft<CR>", { silent = true })
  end,
}
