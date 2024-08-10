return {
  "nvim-pack/nvim-spectre",
  requires = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local spectre = require "spectre"
    local actions = require "spectre.actions"

    spectre.setup {
      mapping = {
        ["select_template"] = {
          map = "<LEADER>rt",
          cmd = "<cmd>lua require('spectre.actions').select_template()<CR>",
          desc = "pick template",
        },
      },
      find_engine = {
        ["rg"] = {
          cmd = "rg",
          args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
          },
        },
        options = {
          ["ignore-case"] = {
            value = "--ignore-case",
            icon = "[I]",
            desc = "ignore case",
          },
          ["hidden"] = {
            value = "--hidden",
            desc = "hidden file",
            icon = "[H]",
          },
        },
      },
      default = {
        find = {
          cmd = "rg",
          options = { "hidden" },
        },
      },
    }

    -- local variables to register search query
    local path = ""
    local search_query = ""
    local replace_query = ""

    -- function that refreshes search query
    local refresh_query = function()
      local state = actions.get_state()
      -- by default, exclude .git directory
      if path == "" then
        path = "!.git/"
      else
        path = state.query.path
      end
      search_query = state.query.search_query
      replace_query = state.query.replace_query
    end

    local keymap = vim.keymap
    keymap.set("n", "<LEADER>rp", function()
      -- keymaps
      refresh_query()
      spectre.toggle { search_text = search_query, replace_query = replace_query, path = path }
    end, { desc = "Toggle Spectre" })

    keymap.set("n", "<LEADER>rw", function()
      spectre.open_visual { select_word = true, path = path }
    end, { desc = "Search current word" })

    keymap.set("v", "<LEADER>rw", function()
      spectre.open_visual { path = path }
    end, { desc = "Search current word" })

    keymap.set("n", "<LEADER>rc", function()
      spectre.open_file_search()
    end, { desc = "Search on current file" })
  end,
}
