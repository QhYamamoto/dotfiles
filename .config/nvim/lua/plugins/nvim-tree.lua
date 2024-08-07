return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function ()
    local nvimtree = require "nvim-tree"
    local keymap = vim.keymap

    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    keymap.set("n", "<LEADER>ee", "<CMD>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
    keymap.set(
      "n",
      "<LEADER>ef",
      "<CMD>NvimTreeFindFileToggle<CR>",
      { desc = "Toggle file explorer on current file" }
    )

    nvimtree.setup {
      open_on_tab = false,
      on_attach = function (bufnr)
        local api = require "nvim-tree.api"

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        api.config.mappings.default_on_attach(bufnr)

        keymap.set("n", "l", api.node.open.edit, opts "Open")
        keymap.set("n", "<Right>", api.node.open.edit, opts "Open")
        keymap.set("n", "h", api.node.navigate.parent_close, opts "Close Directory")
        keymap.set("n", "<Left>", api.node.navigate.parent_close, opts "Close Directory")
      end,
      hijack_cursor = true,
      view = {
        width = 35,
        relativenumber = true,
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
