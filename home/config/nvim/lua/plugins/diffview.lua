return {
  "sindrets/diffview.nvim",
  config = function()
    require("core.keymaps.plugins").diffview.setup()
  end,
}
