return {
  "akinsho/toggleterm.nvim",
  config = function()
    local toggleterm = require "toggleterm"
    toggleterm.setup {
      size = 20,
      open_mapping = { "<M-t>" },
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = false,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    }

    local Terminal = require("toggleterm.terminal").Terminal
    local lazygit = Terminal:new {
      cmd = "lazygit",
      hidden = true,
      direction = "float",
      count = 1000,
    }
    local lazydocker = Terminal:new {
      cmd = "lazydocker",
      hidden = true,
      direction = "float",
      count = 1001,
    }

    function toggle_lazygit()
      lazygit:toggle()
    end

    vim.keymap.set("n", "<leader>lg", "<cmd>lua toggle_lazygit()<CR>", { silent = true })

    function toggle_lazydocker()
      lazydocker:toggle()
    end

    vim.keymap.set("n", "<leader>ld", "<cmd>lua toggle_lazydocker()<CR>", { silent = true })
  end,
}
