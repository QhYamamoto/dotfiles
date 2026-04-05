local M = {}

M.keys = {
  { "<LEADER>mt", ":MakeTable!<CR>", mode = "n", silent = true },
  { "<LEADER>mt", ":'<,'>MakeTable!<CR>", mode = "v", silent = true },
  { "<LEADER>umt", ":'<CMD>UnmakeTable<CR>", mode = "n", silent = true },
}

return M
