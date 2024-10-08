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
  end,
}
