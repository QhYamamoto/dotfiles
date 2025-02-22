return {
  "monaqa/dial.nvim",
  config = function()
    local augend = require "dial.augend"
    local config = require "dial.config"

    config.augends:register_group {
      default = {
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.constant.alias.bool,
        augend.constant.alias.alpha,
        augend.constant.alias.Alpha,
        augend.date.alias["%Y/%m/%d"],
        augend.date.alias["%m/%d/%Y"],
        augend.date.alias["%d/%m/%Y"],
        augend.date.alias["%m/%d/%y"],
        augend.date.alias["%d/%m/%y"],
        augend.date.alias["%m/%d"],
        augend.date.alias["%-m/%-d"],
        augend.date.alias["%Y-%m-%d"],
        augend.date.alias["%d.%m.%Y"],
        augend.date.alias["%d.%m.%y"],
        augend.date.alias["%d.%m."],
        augend.date.alias["%-d.%-m."],
        augend.date.alias["%Y年%-m月%-d日"],
        augend.date.alias["%Y年%-m月%-d日(%ja)"],
        augend.date.alias["%H:%M:%S"],
        augend.date.alias["%H:%M"],
        augend.semver.alias.semver,
      },
    }

    local map = require "dial.map"
    local keymap = vim.keymap

    keymap.set("n", "U", map.inc_normal(), { noremap = true, silent = true, desc = "Increment by dial" })
    keymap.set("v", "U", map.inc_visual(), { noremap = true, silent = true, desc = "Increment by dial" })
    keymap.set("n", "D", map.dec_normal(), { noremap = true, silent = true, desc = "Decrement by dial" })
    keymap.set("v", "D", map.dec_normal(), { noremap = true, silent = true, desc = "Decrement by dial" })
    keymap.set("n", "gU", map.inc_gnormal(), { noremap = true, silent = true, desc = "g incriment by dial" })
    keymap.set("n", "gD", map.dec_gnormal(), { noremap = true, silent = true, desc = "g incriment by dial" })
  end,
}
