local set_maps = require("core.keymaps.plugins.util").set_maps

local M = {}

function M.setup(hop, directions)
  set_maps {
    {
      mode = "n",
      lhs = "f",
      rhs = function()
        hop.hint_char1 { direction = directions.AFTER_CURSOR, current_line_only = true }
      end,
      opts = { remap = true },
    },
    {
      mode = "n",
      lhs = "F",
      rhs = function()
        hop.hint_char1 { direction = directions.BEFORE_CURSOR, current_line_only = true }
      end,
      opts = { remap = true },
    },
    {
      mode = "n",
      lhs = "t",
      rhs = function()
        hop.hint_char1 { direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 }
      end,
      opts = { remap = true },
    },
    {
      mode = "n",
      lhs = "T",
      rhs = function()
        hop.hint_char1 { direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 }
      end,
      opts = { remap = true },
    },
  }
end

return M
