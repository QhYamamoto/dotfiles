return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require "conform"
    local stylua_target_file_path = ""

    conform.setup {
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        liquid = { "prettier" },
        lua = { "stylua" },
        python = { "autopep8" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "beautysh" },
        zshrc = { "beautysh" },
      },
      formatters = {
        beautysh = {
          inherit = true,
          append_args = {
            "-i",
            "2",
          },
        },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    }

    local keymap = vim.keymap
    keymap.set({ "n", "v" }, "<LEADER>mp", function()
      conform.format {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      }
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
