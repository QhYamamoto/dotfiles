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
    set_hl(0, "@comment", { fg = "#8C95A8", italic = true })
    set_hl(0, "Comment", { fg = "#8C95A8", italic = true })
    set_hl(0, "@lsp.type.variable", { fg = "#EC818A", italic = true })
    set_hl(0, "DiagnosticUnnecessary", { fg = "#8A959D", strikethrough = true })
    set_hl(0, "@variable", { fg = "#EC818A", italic = true })

    local cl_bg = vim.fn.synIDattr(vim.fn.hlID "CursorLine", "bg")
    set_hl(0, "Visual", { bg = cl_bg })

    -- Diagnostics settings
    vim.diagnostic.config {
      underline = true,
      signs = true,
      update_in_insert = false,
    }

    set_hl(0, "DiagnosticUnderlineError", { undercurl = false, underline = true, sp = "Red" })
    set_hl(0, "DiagnosticUnderlineWarn", { undercurl = false, underline = true, sp = "Yellow" })
    set_hl(0, "DiagnosticUnderlineInfo", { undercurl = false, underline = true, sp = "Blue" })
    set_hl(0, "DiagnosticUnderlineHint", { undercurl = false, underline = true, sp = "Cyan" })
  end,
}
