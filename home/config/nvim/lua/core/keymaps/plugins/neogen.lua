local M = {}

M.keys = {
  {
    "<LEADER>doc",
    function()
      require("neogen").generate()
    end,
    mode = "n",
    desc = "Generate docstring.",
  },
}

return M
