return {
  "phaazon/hop.nvim",
  branch = "v2",
  config = function()
    local hop = require "hop"

    hop.setup {
      keys = "1234567890fdsvcxrew",
    }

    local keymap = vim.keymap

    local directions = require("hop.hint").HintDirection
    keymap.set("n", "f", function()
      hop.hint_char1 { direction = directions.AFTER_CURSOR, current_line_only = true }
    end, { remap = true })
    keymap.set("n", "F", function()
      hop.hint_char1 { direction = directions.BEFORE_CURSOR, current_line_only = true }
    end, { remap = true })
    keymap.set("n", "t", function()
      hop.hint_char1 { direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 }
    end, { remap = true })
    keymap.set("n", "T", function()
      hop.hint_char1 { direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 }
    end, { remap = true })
  end,
}
