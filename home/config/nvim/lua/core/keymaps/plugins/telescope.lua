local set_maps = require("core.keymaps.plugins.util").set_maps

local M = {}

function M.insert_mappings(actions)
  return {
    i = {
      ["<C-k>"] = actions.move_selection_previous,
      ["<C-j>"] = actions.move_selection_next,
    },
  }
end

function M.setup(open_projects)
  set_maps {
    { mode = "n", lhs = "<LEADER>ff", rhs = "<CMD>Telescope find_files<CR>", desc = "Fuzzy find files in cwd" },
    { mode = "n", lhs = "<LEADER>fr", rhs = "<CMD>Telescope resume<CR>", desc = "Fuzzy find with cache" },
    { mode = "n", lhs = "<LEADER>fp", rhs = open_projects, desc = "Find project" },
    { mode = "n", lhs = "<leader>fs", rhs = "<cmd>Telescope live_grep<CR>", desc = "Find string in cwd" },
    { mode = "n", lhs = "<LEADER>ft", rhs = "<CMD>TodoTelescope<CR>", desc = "Find todos" },
  }
end

return M
