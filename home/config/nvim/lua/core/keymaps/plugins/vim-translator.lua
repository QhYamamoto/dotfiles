local M = {}

M.keys = {
  { "<LEADER>tr", ":TranslateW<CR>", mode = "n", desc = "Translate from en => ja", silent = true },
  { "<LEADER>tr", ":'<,'>TranslateW<CR>", mode = "v", desc = "Translate from en => ja", silent = true },
}

return M
