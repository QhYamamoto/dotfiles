return {
  "phaazon/hop.nvim",
  branch = "v2",
  config = function()
    local plugin_keymaps = require("core.keymaps.plugins").hop
    local hop = require "hop"

    hop.setup {
      keys = "1234567890fdsvcxrew",
    }

    local directions = require("hop.hint").HintDirection
    plugin_keymaps.setup(hop, directions)
  end,
}
