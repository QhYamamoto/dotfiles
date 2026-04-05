local set_maps = require("core.keymaps.plugins.util").set_maps

local M = {}

function M.setup()
  set_maps {
    { mode = "n", lhs = "<LEADER>mp", rhs = "<CMD>MarkdownPreview<CR>", desc = "MarkdownPreview" },
  }
end

return M
