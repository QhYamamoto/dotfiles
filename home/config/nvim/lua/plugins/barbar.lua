return {
  "romgrk/barbar.nvim",
  enabled = function()
    return #vim.api.nvim_list_uis() > 0
  end,
  dependencies = {
    "lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
    "nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
  },
  init = function()
    local plugin_keymaps = require("core.keymaps.plugins").barbar
    vim.g.barbar_auto_setup = false

    vim.api.nvim_create_autocmd("BufDelete", {
      callback = plugin_keymaps.on_buf_delete,
    })

    plugin_keymaps.setup()
  end,
  opts = {
    icons = {
      buffer_index = true,
    },
  },
  version = "^1.0.0", -- optional: only update when a new 1.x version is released
}
