return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  config = function ()
    local comment = require "Comment"
    local api = require "Comment.api"

    local ts_context_commentstring = require "ts_context_commentstring.integrations.comment_nvim"

    comment.setup {
      pre_hook = ts_context_commentstring.create_pre_hook(),
      toggler = {
        line = "<C-_>",
        block = "<S-M-a>",
      },
      opleader = {
        line = "<C-_>",
        block = "<S-M-a>",
      },
    }
  end,
}
