return {
  "navarasu/onedark.nvim",
  priority = 1000,
  config = function()
    local onedark = require "onedark"

    onedark.setup {
      style = "darker",
      transparent = true,
      term_colors = true,
      code_style = {
        comments = "none",
      },
      highlights = {
        LineNr = { fg = "#ABB2BF" },
        DiffChange = { bg = "#3B5469" },
      },
    }
    onedark.load()

    local set_hl = vim.api.nvim_set_hl
    set_hl(0, "WinSeparator", { fg = "#535965", bg = "NONE" })
    set_hl(0, "@lsp.type.comment", { fg = "#8C95A8", italic = true })
    set_hl(0, "@lsp.type.variable", { fg = "#EC818A", italic = true })
  end,
}
