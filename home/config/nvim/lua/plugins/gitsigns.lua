return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(bufnr)
      require("core.keymaps.plugins").gitsigns.on_attach(bufnr)
    end,
    current_line_blame = true,
    current_line_blame_opts = {
      delay = 500,
    },
  },
}
