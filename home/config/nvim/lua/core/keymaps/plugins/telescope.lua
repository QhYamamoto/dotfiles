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
  local builtin = require "telescope.builtin"

  local function find_files_all()
    builtin.find_files {
      find_command = { "rg", "--no-ignore", "--iglob", "!.git", "--hidden", "--files" },
      prompt_title = "Find Files (incl. gitignored)",
    }
  end

  local function live_grep_all()
    builtin.live_grep {
      additional_args = { "--no-ignore", "--hidden" },
      prompt_title = "Live Grep (incl. gitignored)",
    }
  end

  set_maps {
    { mode = "n", lhs = "<LEADER>ff", rhs = "<CMD>Telescope find_files<CR>", desc = "Fuzzy find files in cwd" },
    { mode = "n", lhs = "<LEADER>fF", rhs = find_files_all, desc = "Fuzzy find files incl. gitignored" },
    { mode = "n", lhs = "<LEADER>fr", rhs = "<CMD>Telescope resume<CR>", desc = "Fuzzy find with cache" },
    { mode = "n", lhs = "<LEADER>fp", rhs = open_projects, desc = "Find project" },
    { mode = "n", lhs = "<leader>fs", rhs = "<cmd>Telescope live_grep<CR>", desc = "Find string in cwd" },
    { mode = "n", lhs = "<LEADER>fS", rhs = live_grep_all, desc = "Find string incl. gitignored" },
    { mode = "n", lhs = "<LEADER>ft", rhs = "<CMD>TodoTelescope<CR>", desc = "Find todos" },
  }
end

return M
