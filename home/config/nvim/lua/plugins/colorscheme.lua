return {
  "sainnhe/everforest",
  priority = 1000,
  config = function()
    vim.g.everforest_background = "hard"
    vim.g.everforest_transparent_background = 0
    vim.g.everforest_better_performance = 1
    vim.o.background = "dark"
    vim.cmd.colorscheme "everforest"

    local parameter_hl = { fg = "#e69875" }
    vim.api.nvim_set_hl(0, "@variable.parameter", parameter_hl)
    vim.api.nvim_set_hl(0, "@lsp.type.parameter", parameter_hl)

    vim.diagnostic.config {
      underline = true,
      signs = true,
      update_in_insert = false,
    }
  end,
}
