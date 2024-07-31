return {
  "nvim-pack/nvim-spectre",
  requires = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local keymap = vim.keymap;

    keymap.set("n", "<LEADER>fs", '<CMD>lua require("spectre").toggle()<CR>', {
      desc = "Toggle Spectre"
    })
    keymap.set("n", "<LEADER>fw", '<CMD>lua require("spectre").open_visual({select_word=true})<CR>', {
      desc = "Search current word"
    })
    keymap.set("v", "<LEADER>fw", '<esc><CMD>lua require("spectre").open_visual()<CR>', {
      desc = "Search current word"
    })
    keymap.set("n", "<LEADER>fc", '<CMD>lua require("spectre").open_file_search({select_word=false})<CR>', {
      desc = "Search on current file"
    })
  end
}
