return {
  "nvim-pack/nvim-spectre",
  requires = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local spectre = require("spectre")

    spectre.setup({
      find_engine = {
        ["rg"] = {
          cmd = "rg",
          args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
          },
        },
        options = {
          ["ignore-case"] = {
            value = "--ignore-case",
            icon = "[I]",
            desc = "ignore case"
          },
          ["hidden"] = {
            value = "--hidden",
            desc = "hidden file",
            icon = "[H]"
          },
        },
      },
      default = {
        find = {
          cmd = "rg",
          options = { "hidden" }
        },
      },
    })

    local keymap = vim.keymap;

    keymap.set(
      "n",
      "<LEADER>fs",
      "<CMD>lua require('spectre').toggle({ path = '!.git/' })<CR>",
      { desc = "Toggle Spectre" }
    )
    keymap.set(
      "n",
      "<LEADER>fw",
      "<CMD>lua require('spectre').open_visual({ select_word=true, path = '!.git/' })<CR>",
      { desc = "Search current word" }
    )
    keymap.set(
      "v",
      "<LEADER>fw",
      "<ESC><CMD>lua require('spectre').open_visual({ path = '!.git/' })<CR>",
      { desc = "Search current word" }
    )
    keymap.set(
      "n",
      "<LEADER>fc",
      "<CMD>lua require('spectre').open_file_search()<CR>",
      { desc = "Search on current file" }
    )
  end
}
