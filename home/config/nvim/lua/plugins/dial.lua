return {
  "monaqa/dial.nvim",
  config = function()
    local dial = require "dial.map"
    local keymap = vim.keymap

    keymap.set("n", "U", dial.inc_normal(), { noremap = true, silent = true, desc = "Increment by dial" })
    keymap.set("v", "U", dial.inc_visual(), { noremap = true, silent = true, desc = "Increment by dial" })
    keymap.set("n", "D", dial.dec_normal(), { noremap = true, silent = true, desc = "Decrement by dial" })
    keymap.set("v", "D", dial.dec_normal(), { noremap = true, silent = true, desc = "Decrement by dial" })
    keymap.set("n", "gU", dial.inc_gnormal(), { noremap = true, silent = true, desc = "g incriment by dial" })
    keymap.set("n", "gD", dial.dec_gnormal(), { noremap = true, silent = true, desc = "g incriment by dial" })
  end,
}
