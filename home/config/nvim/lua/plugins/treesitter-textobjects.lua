return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  lazy = true,
  config = function()
    require("nvim-treesitter.configs").setup {
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ia"] = "@parameter.inner",
            ["aa"] = "@parameter.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>ll"] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>hh"] = "@parameter.inner",
          },
        },
      },
    }
  end,
}
