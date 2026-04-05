return {
  "gbprod/substitute.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local substitute = require "substitute"

    substitute.setup()

    require("core.keymaps.plugins").substitute.setup(substitute)
  end,
}
