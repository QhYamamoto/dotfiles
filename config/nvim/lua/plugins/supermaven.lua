return {
  "supermaven-inc/supermaven-nvim",
  config = function()
    local supermaven = require "supermaven-nvim"
    supermaven.setup {
      condition = function()
        return true
      end,
    }
  end,
}
