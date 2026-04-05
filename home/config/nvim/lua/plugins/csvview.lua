return {
  "hat0uma/csvview.nvim",
  keys = require("core.keymaps.plugins").csvview.keys,
  config = function()
    local csvview = require "csvview"
    csvview.setup {
      view = {
        display_mode = "border",
      },
    }
  end,
}
