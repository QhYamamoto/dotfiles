return {
  "navarasu/onedark.nvim",
  priority = 1000,
  config = function()
    local onedark = require("onedark")

    onedark.setup({
      style = "darker",
      transparent = true,
      term_colors = true,
      code_style = {
        comments = 'none'
      },
      highlights = {
        LineNr = { fg = "#ABB2BF" },
        ["@comment"] = { fg = "#8C95A8" },
      },
    })

    onedark.load()

    vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#535965", bg = "NONE" })
  end,
}
