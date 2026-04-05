local set_maps = require("core.keymaps.plugins.util").set_maps

local M = {}

M.buffer_keymaps = {
  ["q"] = { "actions.close", mode = "n" },
  ["<M-t>"] = { "actions.close", mode = "n" },
  ["h"] = { "actions.parent", mode = "n" },
  ["<C-s>"] = false,
}

function M.setup()
  set_maps {
    { mode = "n", lhs = "<LEADER>ol", rhs = "<CMD>Oil --float<CR>", desc = "Open oil buffer in floating view" },
  }
end

return M
