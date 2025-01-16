return {
  "hat0uma/csvview.nvim",
  config = function()
    local csvview = require "csvview"
    csvview.setup {
      view = {
        display_mode = "border",
      },
    }

    local keymap = vim.keymap

    keymap.set("n", "<LEADER>csv", "<CMD>CsvViewToggle<CR>", { desc = "Toggle csv view" })
  end,
}
