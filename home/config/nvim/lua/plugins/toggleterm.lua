return {
  "akinsho/toggleterm.nvim",
  config = function()
    local plugin_keymaps = require("core.keymaps.plugins").toggleterm
    local toggleterm = require "toggleterm"
    toggleterm.setup {
      size = 20,
      -- open_mapping = { "<M-t>" },
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
        border = "double",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    }

    plugin_keymaps.register_tool("lazygit", {
      cmd = "lazygit",
      hidden = true,
      direction = "float",
    })

    plugin_keymaps.register_tool("lazydocker", {
      cmd = "lazydocker",
      hidden = true,
      direction = "float",
    })

    plugin_keymaps.register_tool("lazysql", {
      cmd = "lazysql",
      hidden = true,
      direction = "float",
    })

    plugin_keymaps.register_tool("broot", {
      cmd = "broot --conf ~/.config/broot/config.toml",
      hidden = true,
      direction = "float",
    })

    plugin_keymaps.setup()
  end,
}
