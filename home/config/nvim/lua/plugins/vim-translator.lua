return {
  "voldikss/vim-translator",
  config = function()
    vim.g.translator_target_lang = "ja"
    vim.translator_default_engines = { "google" }

    require("core.keymaps.plugins").vim_translator.setup()
  end,
}
