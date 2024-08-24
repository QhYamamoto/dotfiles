return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  config = function()
    local noice = require "noice"
    noice.setup {
      lsp = {
        signature = {
          enabled = false,
        },
      },
    }

    local notify = require "notify"
    notify.setup {
      background_colour = "#000000",
    }
  end,
}
