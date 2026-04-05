return {
  "danymat/neogen",
  keys = require("core.keymaps.plugins").neogen.keys,
  config = function()
    local neogen = require "neogen"

    neogen.setup {}
  end,
}
