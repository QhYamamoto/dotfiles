return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require "conform"

    local FILETYPES_TO_DISABLE_AUTO_FORMAT = {} --[[ { "php", "blade" } ]]

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
        php = { "php-cs-fixer" },
        python = { "autopep8" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "beautysh" },
        zshrc = { "beautysh" },
        blade = { "blade-formatter" },
        vue = { "prettier" },
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
      format_on_save = function(bufnr)
        -- Disable format_on_save according to current buffer's filetype
        local current_filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
        for _, file_type_to_disable_auto_format in ipairs(FILETYPES_TO_DISABLE_AUTO_FORMAT) do
          if current_filetype == file_type_to_disable_auto_format then
            return
          end
        end

        return {
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        }
      end,
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
