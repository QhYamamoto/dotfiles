return {
  "akinsho/git-conflict.nvim",
  version = "*",
  config = function()
    local git_conflict = require("git-conflict");

    local keymap = vim.keymap;

    git_conflict.setup({
      default_mappings = {
        next = "]x",
        prev = "[x",
      },
    })
  end,
}
