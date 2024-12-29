return {
  "supermaven-inc/supermaven-nvim",
  config = function()
    local supermaven = require "supermaven-nvim"
    supermaven.setup {
      keymaps = {
        accept_suggestion = "<C-j>",
        accept_word = "<C-l>",
      },
      color = {
        suggestion_color = "#545964",
        cterm = 240,
      },
      condition = function()
        return true
      end,
    }

    local keymap = vim.keymap
    local supermaven_api = require "supermaven-nvim.api"

    keymap.set("n", "<LEADER>ms", function()
      supermaven_api.start()
    end, { silent = true, desc = "Start SuperMaven" })

    keymap.set("n", "<LEADER>mS", function()
      supermaven_api.stop()
    end, { silent = true, desc = "Stop SuperMaven" })
  end,
}
