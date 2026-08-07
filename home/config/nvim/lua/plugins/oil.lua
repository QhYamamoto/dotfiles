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
        -- oilのフロートは枠(border)がある時だけ、現在のディレクトリパスを枠の
        -- タイトルとして表示する。Neovim 0.12でwinborder未設定時のフロート既定が
        -- 枠なしになったため、明示的に枠を付けてパスが出るようにする。
        border = "rounded",
      },
      view_options = {
        show_hidden = true,
      },
    }

    oil.setup(opts)

    plugin_keymaps.setup()
  end,
}
