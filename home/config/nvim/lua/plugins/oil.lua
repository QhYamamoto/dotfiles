return {
  "stevearc/oil.nvim",
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local plugin_keymaps = require("core.keymaps.plugins").oil
    local oil = require "oil"

    ---@type oil.SetupOpts
    local opts = {
      keymaps = plugin_keymaps.buffer_keymaps,
      float = {
        padding = 5,
      },
      view_options = {
        show_hidden = true,
      },
    }

    oil.setup(opts)

    plugin_keymaps.setup()
  end,
}
