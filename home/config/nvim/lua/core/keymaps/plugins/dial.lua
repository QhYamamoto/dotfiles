local set_maps = require("core.keymaps.plugins.util").set_maps

local M = {}

function M.setup(dial_map)
  set_maps {
    {
      mode = "n",
      lhs = "U",
      rhs = dial_map.inc_normal(),
      desc = "Increment by dial",
      opts = { noremap = true, silent = true },
    },
    {
      mode = "v",
      lhs = "U",
      rhs = dial_map.inc_visual(),
      desc = "Increment by dial",
      opts = { noremap = true, silent = true },
    },
    {
      mode = "n",
      lhs = "D",
      rhs = dial_map.dec_normal(),
      desc = "Decrement by dial",
      opts = { noremap = true, silent = true },
    },
    {
      mode = "v",
      lhs = "D",
      rhs = dial_map.dec_normal(),
      desc = "Decrement by dial",
      opts = { noremap = true, silent = true },
    },
    {
      mode = "n",
      lhs = "gU",
      rhs = dial_map.inc_gnormal(),
      desc = "g incriment by dial",
      opts = { noremap = true, silent = true },
    },
    {
      mode = "n",
      lhs = "gD",
      rhs = dial_map.dec_gnormal(),
      desc = "g incriment by dial",
      opts = { noremap = true, silent = true },
    },
  }
end

return M
