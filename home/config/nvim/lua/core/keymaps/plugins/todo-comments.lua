local set_maps = require("core.keymaps.plugins.util").set_maps

local M = {}

function M.setup(todo_comments)
  set_maps {
    { mode = "n", lhs = "]t", rhs = todo_comments.jump_next, desc = "Next todo comment" },
    { mode = "n", lhs = "[t", rhs = todo_comments.jump_prev, desc = "Previous todo comment" },
  }
end

return M
