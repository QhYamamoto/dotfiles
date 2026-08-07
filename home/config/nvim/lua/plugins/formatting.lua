return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local plugin_keymaps = require("core.keymaps.plugins").formatting
    local conform = require "conform"

    local FILETYPES_TO_DISABLE_AUTO_FORMAT = { "yml", "yaml", "blade" }

    conform.setup {
      formatters_by_ft = {
        -- Biome（フォーマット + リント）
        javascript = { "biome" },
        typescript = { "biome" },
        javascriptreact = { "biome" },
        typescriptreact = { "biome" },
        json = { "biome" },
        jsonc = { "biome" },
        -- Prettier（Biome非対応のファイルタイプ）
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        liquid = { "prettier" },
        vue = { "prettier" },
        -- その他
        lua = { "stylua" },
        php = { "pint" },
        python = { "ruff" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "beautysh" },
        zshrc = { "beautysh" },
        blade = { "blade-formatter" },
        sql = { "sql_formatter" },
      },
      formatters = {
        -- biome check --write でフォーマット + organize imports + safe lint fix
        biome = {
          command = "biome",
          args = { "check", "--write", "$FILENAME" },
          stdin = false,
        },
        beautysh = {
          inherit = true,
          append_args = {
            "-i",
            "2",
          },
        },
        ruff = {
          cmd = {
            "ruff",
            "format",
          },
        },
      },
      format_on_save = function(bufnr)
        -- Disable format_on_save according to current buffer's filetype
        local current_filetype = vim.bo[bufnr].filetype
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

    plugin_keymaps.setup(conform)

    vim.api.nvim_create_user_command("Format", function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, end_line:len() },
        }
      end
      require("conform").format { async = true, lsp_format = "fallback", range = range }
    end, { range = true })
  end,
}
