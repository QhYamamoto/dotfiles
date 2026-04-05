return {
  "danymat/neogen",
  config = function()
    local neogen = require "neogen"

    neogen.setup {}

    require("core.keymaps.plugins").neogen.setup()
  end,
}
