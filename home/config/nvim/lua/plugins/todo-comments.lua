return {
  "folke/todo-comments.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local todo_comments = require "todo-comments"

    require("core.keymaps.plugins").todo_comments.setup(todo_comments)

    todo_comments.setup()
  end,
}
