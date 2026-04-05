return {
  "arthurxavierx/vim-caser",
  event = "VeryLazy",
  init = function()
    -- disable default mappings
    vim.g.caser_no_mappings = 1

    require("core.keymaps.plugins").vim_caser.setup()
  end,
}
