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
        border = "rounded",
        padding = 5,
        override = function(conf)
          conf.title = "Oil"
          conf.title_pos = "left"
          return conf
        end,
      },
      view_options = {
        show_hidden = true,
      },
    }

    oil.setup(opts)

    plugin_keymaps.setup()
  end,
}
