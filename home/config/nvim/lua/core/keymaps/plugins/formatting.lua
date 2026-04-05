local set_maps = require("core.keymaps.plugins.util").set_maps

local M = {}

function M.setup(conform)
  set_maps {
    {
      mode = { "n", "v" },
      lhs = "<LEADER>mp",
      rhs = function()
        conform.format {
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        }
      end,
      desc = "Format file or range (in visual mode)",
    },
  }
end

return M
