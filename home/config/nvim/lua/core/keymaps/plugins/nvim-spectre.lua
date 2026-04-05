local set_maps = require("core.keymaps.plugins.util").set_maps

local M = {}

M.panel_mappings = {
  select_template = {
    map = "<LEADER>rt",
    cmd = "<cmd>lua require('spectre.actions').select_template()<CR>",
    desc = "pick template",
  },
  toggle_line = {
    map = "dl",
    cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
    desc = "toggle item",
  },
  delete_line = {
    map = "dd",
    cmd = '"_dd',
    desc = "delete line",
  },
}

local state = {
  path = "",
  search_query = "",
  replace_query = "",
}

function M.setup(spectre, actions)
  local refresh_query = function()
    local current = actions.get_state()
    if state.path == "" then
      state.path = "!.git/"
    else
      state.path = current.query.path
    end
    state.search_query = current.query.search_query
    state.replace_query = current.query.replace_query
  end

  set_maps {
    {
      mode = "n",
      lhs = "<LEADER>rp",
      rhs = function()
        refresh_query()
        spectre.toggle {
          search_text = state.search_query,
          replace_query = state.replace_query,
          path = state.path,
        }
      end,
      desc = "Toggle Spectre",
    },
    {
      mode = "n",
      lhs = "<LEADER>rw",
      rhs = function()
        spectre.open_visual { select_word = true, path = state.path }
      end,
      desc = "Search current word",
    },
    {
      mode = "v",
      lhs = "<LEADER>rw",
      rhs = function()
        spectre.open_visual { path = state.path }
      end,
      desc = "Search current word",
    },
    {
      mode = "n",
      lhs = "<LEADER>rc",
      rhs = function()
        spectre.open_file_search()
      end,
      desc = "Search on current file",
    },
  }
end

return M
