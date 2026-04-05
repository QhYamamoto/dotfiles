local set_maps = require("core.keymaps.plugins.util").set_maps

local M = {}

function M.setup()
  local rhs_for_j = function()
    return "<Plug>(accelerated_jk_" .. (vim.v.count == 0 and "gj" or "j") .. ")"
  end

  local rhs_for_k = function()
    return "<Plug>(accelerated_jk_" .. (vim.v.count == 0 and "gk" or "k") .. ")"
  end

  set_maps {
    { mode = "n", lhs = "j", rhs = rhs_for_j, opts = { noremap = false, silent = true, expr = true } },
    { mode = "n", lhs = "<Down>", rhs = rhs_for_j, opts = { noremap = false, silent = true, expr = true } },
    { mode = "n", lhs = "k", rhs = rhs_for_k, opts = { noremap = false, silent = true, expr = true } },
    { mode = "n", lhs = "<Up>", rhs = rhs_for_k, opts = { noremap = false, silent = true, expr = true } },
  }
end

return M
