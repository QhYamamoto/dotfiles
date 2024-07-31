return {
  "navarasu/onedark.nvim",
  priority = 1000,
  config = function()
    local onedark = require("onedark")

    onedark.setup({
      style = "darker",
      transparent = true,
      term_colors = true,
      highlights = {
        LineNr = { fg = "#ABB2BF" },
      },
    })

    onedark.load()

    vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#535965', bg = 'NONE' })
  end,
}
