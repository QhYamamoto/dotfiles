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

    local function command_display()
      if vim.fn.reg_recording() ~= "" then
        return "Recording @" .. vim.fn.reg_recording()
      else
        return ""
      end
    end

    transparent.clear_prefix "lualine"

    -- configure lualine with modified theme
    lualine.setup {
      options = {
        theme = "onedark",
      },
      sections = {
        lualine_c = { command_display },
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
          },
          { "encoding" },
          { "fileformat" },
          { "filetype" },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
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
