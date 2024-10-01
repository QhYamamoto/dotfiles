return {
  "voldikss/vim-translator",
  config = function()
    vim.g.translator_target_lang = "ja"
    vim.translator_default_engines = { "google" }

    local keymap = vim.keymap

    keymap.set("n", "<LEADER>tr", ":TranslateW<CR>", { desc = "Translate from en => ja", silent = true })
    keymap.set("v", "<LEADER>tr", ":'<,'>TranslateW<CR>", { desc = "Translate from en => ja", silent = true })
  end,
}
