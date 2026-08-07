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

        return { "treesitter", "indent" }
      end,
    }

    -- conform等によるバッファ書き換え後にfoldが閉じるのを防止
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = vim.api.nvim_create_augroup("UfoPreserveFolds", { clear = true }),
      callback = function()
        vim.defer_fn(function()
          if vim.wo.foldenable then
            vim.wo.foldlevel = 99
          end
        end, 100)
      end,
    })

    -- バッファ表示時にfoldlevelを再適用（auto-session復元対策）
    vim.api.nvim_create_autocmd("BufWinEnter", {
      group = vim.api.nvim_create_augroup("UfoInitFolds", { clear = true }),
      callback = function()
        vim.defer_fn(function()
          if vim.wo.foldenable then
            vim.wo.foldlevel = 99
          end
        end, 100)
      end,
    })
  end,
}
