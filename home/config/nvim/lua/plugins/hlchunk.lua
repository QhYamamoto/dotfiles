return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("hlchunk").setup {
      chunk = {
        enable = true,
        style = {
          { fg = "Cyan" },
          { fg = "#c21f30" },
        },
      },

      indent = {
        enable = true,
        use_treesitter = false,
        chars = {
          " ",
        },
        style = {
          { bg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID "Whitespace"), "fg", "gui") },
        },
      },

      line_num = {
        enable = true,
        use_treesitter = false,
        style = "Cyan",
      },
    }
  end,
}
