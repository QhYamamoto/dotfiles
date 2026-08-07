return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    spec = {
      { "<leader>a", group = "ai / claude" },
      { "<leader>b", group = "buffer" },
      { "<leader>c", group = "case / codex / code" },
      { "<leader>d", group = "diagnostic / docstring" },
      { "<leader>e", group = "explorer" },
      { "<leader>f", group = "find" },
      { "<leader>g", group = "git / diff" },
      { "<leader>h", group = "hunk" },
      { "<leader>l", group = "TUI tools (git/docker/sql/squad)" },
      { "<leader>m", group = "markdown / make / format" },
      { "<leader>n", group = "numbers" },
      { "<leader>o", group = "open / organize" },
      { "<leader>r", group = "replace / rename / restore" },
      { "<leader>s", group = "split / size" },
      { "<leader>t", group = "toggle / tree" },
      { "<leader>u", group = "unmake table" },
      { "<leader>w", group = "workspace / session" },
      { "<leader>x", group = "trouble" },
      { "<leader>y", group = "yank / copy" },
      { "<leader>z", group = "fold" },
    },
  },
}
