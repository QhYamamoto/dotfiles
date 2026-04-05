return {
  "hat0uma/csvview.nvim",
  config = function()
    local csvview = require "csvview"
    csvview.setup {
      view = {
        display_mode = "border",
      },
    }

    require("core.keymaps.plugins").csvview.setup()
  end,
}
