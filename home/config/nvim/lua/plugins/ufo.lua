return {
  "kevinhwang91/nvim-ufo",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "kevinhwang91/promise-async",
  },
  config = function()
    local ufo = require "ufo"

    vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })
    vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })
    vim.keymap.set("n", "zK", ufo.peekFoldedLinesUnderCursor, { desc = "Peek folded lines under cursor" })

    ufo.setup {
      provider_selector = function(_, filetype, buftype)
        if buftype ~= "" or filetype == "markdown" or filetype == "text" or filetype == "gitcommit" then
          return ""
        end

        return { "indent" }
      end,
    }
  end,
}
