return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require "lint"

    lint.linters_by_ft = {
      python = { "mypy" },
    }

    -- mypyの設定: プロジェクトの.venvを使用
    lint.linters.mypy = {
      cmd = "mypy",
      stdin = false,
      args = {
        "--show-column-numbers",
        "--show-error-codes",
        "--no-error-summary",
        "--no-pretty",
        function()
          -- プロジェクトルートの.venvを探す
          local venv = vim.fn.finddir(".venv", vim.fn.getcwd() .. ";")
          if venv ~= "" then
            return "--python-executable=" .. venv .. "/bin/python"
          end
          return nil
        end,
      },
      ignore_exitcode = true,
      stream = "stdout",
      parser = require("lint.parser").from_pattern(
        "([^:]+):(%d+):(%d+): (%a+): (.+)",
        { "file", "lnum", "col", "severity", "message" },
        {
          error = vim.diagnostic.severity.ERROR,
          warning = vim.diagnostic.severity.WARN,
          note = vim.diagnostic.severity.HINT,
        }
      ),
    }

    -- 保存時とInsertLeave時にlintを実行
    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "BufEnter" }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
