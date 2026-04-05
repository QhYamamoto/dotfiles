return {
  "mattn/vim-maketable",
  config = function()
    require("core.keymaps.plugins").vim_maketable.setup()
  end,
}
