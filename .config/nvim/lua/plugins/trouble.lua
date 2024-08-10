return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
  keys = {
    { "<LEADER>xx", "<CMD>TroubleToggle<CR>", desc = "Open/close trouble list" },
    { "<LEADER>xw", "<CMD>TroubleToggle workspace_diagnostics<CR>", desc = "Open trouble workspace diagnostics" },
    { "<LEADER>xd", "<CMD>TroubleToggle document_diagnostics<CR>", desc = "Open trouble document diagnostics" },
    { "<LEADER>xq", "<CMD>TroubleToggle quickfix<CR>", desc = "Open trouble quickfix list" },
    { "<LEADER>xl", "<CMD>TroubleToggle loclist<CR>", desc = "Open trouble location list" },
    { "<LEADER>xt", "<CMD>TodoTrouble<CR>", desc = "Open todos in trouble" },
  },
}
