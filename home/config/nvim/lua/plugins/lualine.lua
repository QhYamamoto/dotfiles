return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "xiyaowong/transparent.nvim",
  },
  config = function()
    local lualine = require "lualine"
    local lazy_status = require "lazy.status" -- to configure lazy pending updates count
    local transparent = require "transparent"

    transparent.clear_prefix "lualine"

    -- configure lualine with modified theme
    lualine.setup {
      options = {
        theme = "onedark",
        section_separators = "",
        component_separators = "",
      },
      sections = {
        lualine_a = {
          {
            "mode",
            padding = { left = 1, right = 0 },
          },
          {
            function()
              local row, col = unpack(vim.api.nvim_win_get_cursor(0))
              return string.format(" @ L:%d Col:%d", row, col)
            end,
            color = function()
              local themes = require "lualine.themes.auto"
              local mode = vim.fn.mode()
              return themes[mode] or themes.normal
            end,
            padding = { left = 0, right = 1 },
          },
        },
        lualine_c = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
          },
          { "encoding" },
          { "filetype" },
          function() -- Show current recording register.
            if vim.fn.reg_recording() ~= "" then
              return "Recording @" .. vim.fn.reg_recording()
            else
              return ""
            end
          end,
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    }

    vim.api.nvim_create_augroup("LualineCmdline", { clear = true })
    vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
      group = "LualineCmdline",
      callback = function()
        require("lualine").refresh()
      end,
    })
  end,
}
