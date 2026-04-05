return {
  "voldikss/vim-translator",
  keys = require("core.keymaps.plugins").vim_translator.keys,
  config = function()
    vim.g.translator_target_lang = "ja"
    vim.translator_default_engines = { "google" }
  end,
}
