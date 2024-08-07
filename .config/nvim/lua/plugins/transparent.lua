return {
  "xiyaowong/transparent.nvim",
  config = function ()
    local transparent = require "transparent"

    transparent.setup {
      extra_groups = {
        "NormalFloat", -- plugins which have float panel such as Lazy, Mason, LspInfo
        "NvimTreeNormal", -- NvimTree
      },
    }
  end,
}
