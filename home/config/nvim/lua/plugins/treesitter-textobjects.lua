return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  lazy = true,
  config = function()
    require("nvim-treesitter.configs").setup {
      textobjects = {
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
