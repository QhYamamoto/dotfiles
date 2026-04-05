return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local plugin_keymaps = require("core.keymaps.plugins").nvim_tree
    local nvimtree = require "nvim-tree"

    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    plugin_keymaps.setup()

    nvimtree.setup {
      open_on_tab = false,
      on_attach = plugin_keymaps.on_attach,
      hijack_cursor = true,
      view = {
        width = 35,
        relativenumber = true,
        adaptive_size = true,
      },
      -- change folder arrow icons
      renderer = {
        indent_markers = {
          enable = true,
        },
        icons = {
          glyphs = {
            folder = {
              arrow_closed = ">", -- arrow when folder is closed
              arrow_open = "˅", -- arrow when folder is open
            },
          },
        },
      },
      -- disable window_picker for
      -- explorer to work well with
      -- window splits
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
          quit_on_open = true,
        },
      },
      filters = {
        custom = { ".DS_Store" },
      },
      git = {
        ignore = false,
      },
    }
  end,
}
