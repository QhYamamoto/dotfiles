return {
  "nvim-pack/nvim-spectre",
  requires = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local plugin_keymaps = require("core.keymaps.plugins").nvim_spectre
    local spectre = require "spectre"
    local actions = require "spectre.actions"

    spectre.setup {
      mapping = plugin_keymaps.panel_mappings,
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

    plugin_keymaps.setup(spectre, actions)
  end,
}
