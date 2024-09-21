return {
  "akinsho/toggleterm.nvim",
  config = function()
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
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    }

    local tui_tools = {}
    local function get_opened_tui_tool()
      local result = nil
      foreach(tui_tools, function(tui_tool, _)
        if tui_tool:is_open() then
          result = tui_tool
        end
      end)
      return result
    end
    local add_tui_tool = function(label, settings, open_cmd)
      settings.count = 1000 + (#tui_tools - 1)
      local Terminal = require("toggleterm.terminal").Terminal
      local this_tool = Terminal:new(settings)
      tui_tools[#tui_tools + 1] = this_tool

      -- define function for toggling this tui tool
      _G["toggle_" .. label] = function()
        -- if this tool is closed, close currently opened tui tool.
        local is_open = this_tool:is_open()
        if not is_open then
          local opened_tui_tool = get_opened_tui_tool()
          if opened_tui_tool then
            opened_tui_tool:toggle()
          end
        end

        this_tool:toggle()
        is_open = not is_open
        vim.defer_fn(function()
          if is_open then -- if state's been changed from `close` → `open`, set neovim to insertmode
            vim.api.nvim_command "startinsert"
          end
        end, 100)
      end

      vim.keymap.set("n", open_cmd, "<CMD>lua toggle_" .. label .. "()<CR>", { silent = true })
    end

    add_tui_tool("lazygit", {
      cmd = "lazygit",
      hidden = true,
      direction = "float",
    }, "<LEADER>lg")

    add_tui_tool("lazydocker", {
      cmd = "lazydocker",
      hidden = true,
      direction = "float",
    }, "<LEADER>ld")

    add_tui_tool("lazysql", {
      cmd = "lazysql",
      hidden = true,
      direction = "float",
    }, "<LEADER>ls")

    add_tui_tool("broot", {
      cmd = "broot --conf ~/.config/broot/config.toml -c :z",
      hidden = true,
      direction = "float",
    }, "<LEADER>br")

    -- Custom toggle cmd
    vim.keymap.set("n", "<M-t>", function()
      local count = tonumber(vim.v.count) > 0 and tonumber(vim.v.count) or 1
      vim.cmd("ToggleTerm " .. count)
    end, { noremap = true, silent = true })
    vim.keymap.set("t", "<M-t>", function()
      local opened_tui_tool = get_opened_tui_tool()
      if opened_tui_tool then
        opened_tui_tool:toggle()
      else
        vim.cmd "ToggleTerm"
      end
    end, { noremap = true, silent = true })
  end,
}
