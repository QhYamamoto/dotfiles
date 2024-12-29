return {
  "danymat/neogen",
  config = function()
    local neogen = require "neogen"

    neogen.setup {}

    local keymap = vim.keymap
    keymap.set("n", "<LEADER>doc", ":lua require('neogen').generate()<CR>", { desc = "Generate docstring." })
  end,
}
