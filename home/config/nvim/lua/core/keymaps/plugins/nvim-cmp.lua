local set_maps = require("core.keymaps.plugins.util").set_maps

local M = {}

function M.setup(luasnip)
  set_maps {
    {
      mode = { "i", "s" },
      lhs = "<Tab>",
      rhs = function()
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", true)
        end
      end,
      opts = { silent = true },
    },
    {
      mode = { "i", "s" },
      lhs = "<S-Tab>",
      rhs = function()
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CMD><<CR>", true, false, true), "n", true)
        end
      end,
      opts = { silent = true },
    },
  }
end

return M
