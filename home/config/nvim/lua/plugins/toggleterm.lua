return {
  "akinsho/toggleterm.nvim",
  config = function()
    local plugin_keymaps = require("core.keymaps.plugins").toggleterm
    local toggleterm = require "toggleterm"
    toggleterm.setup {
      size = 20,
      -- open_mapping = { "<M-t>" },
      hide_numbers = false,
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
      on_open = function(term)
        local opts = { buffer = term.bufnr, noremap = true, silent = true }
        vim.keymap.set("t", "<C-h>", "<C-h>", opts)
        vim.keymap.set("t", "<C-j>", "<C-j>", opts)
        vim.keymap.set("t", "<C-k>", "<C-k>", opts)
        vim.keymap.set("t", "<C-l>", "<C-l>", opts)
        vim.wo.number = term.numbers ~= false
        vim.wo.relativenumber = term.numbers ~= false
      end,
    }

    function _G.lazygit_open(file_b64, line)
      vim.schedule(function()
        local ok, file = pcall(vim.base64.decode, file_b64)
        if not ok or not file or file == "" then
          return
        end

        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local cfg = vim.api.nvim_win_get_config(win)
          if cfg.relative ~= "" then
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "terminal" then
              pcall(vim.api.nvim_win_close, win, false)
            end
          end
        end

        vim.cmd("edit " .. vim.fn.fnameescape(file))
        if line and line > 0 then
          pcall(vim.api.nvim_win_set_cursor, 0, { line, 0 })
        end
      end)
      return ""
    end

    plugin_keymaps.register_tool("lazygit", {
      cmd = "lazygit",
      hidden = true,
      direction = "float",
      numbers = false,
    })

    plugin_keymaps.register_tool("lazydocker", {
      cmd = "lazydocker",
      hidden = true,
      direction = "float",
      numbers = false,
    })

    plugin_keymaps.register_tool("lazysql", {
      cmd = "lazysql",
      hidden = true,
      direction = "float",
      numbers = false,
    })

    plugin_keymaps.register_tool("claude-squad", {
      cmd = "cs",
      hidden = true,
      direction = "float",
      numbers = false,
      float_opts = {
        width = function()
          return math.floor(vim.o.columns * 0.9)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.9)
        end,
      },
    })

    plugin_keymaps.setup()
  end,
}
