return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPre", "BufNewFile" },
  main = "ibl",
  config = function()
    local highlight = {
      "TermCursor",
      "Whitespace",
    }

    require("ibl").setup {
      indent = { highlight = highlight, char = "" },
      whitespace = { highlight = highlight },
      scope = { enabled = false },
    }
  end,
}
