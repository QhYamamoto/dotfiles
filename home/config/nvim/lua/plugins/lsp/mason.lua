return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require "mason"
    local mason_lspconfig = require "mason-lspconfig"
    local mason_tool_installer = require "mason-tool-installer"

    mason.setup {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    }

    mason_lspconfig.setup {
      ensure_installed = {
        "html",
        -- "cssls",
        "lua_ls",
        "emmet_ls",
        "powershell_es",
        "basedpyright",
        "ruff",
        "biome",
        "ts_ls",
        "bashls",
        "intelephense",
        "prismals",
        "yamlls",
        "rust_analyzer",
      },
      -- mason-lspconfig 2.0 の automatic_enable は「mason導入済みパッケージ全部」を
      -- 走査してLSP化する。そのためmason-tool-installerで入れたフォーマッタ(stylua等)
      -- まで lsp/*.lua 設定があると LSP として起動され `stylua --lsp` 等で毎回クラッシュする。
      -- exclude(ブラックリスト)だと将来別フォーマッタがLSP化されると再発するため、
      -- 実際のLSPサーバーだけの許可リストにする(excludeキー無しのテーブル=許可リスト)。
      -- rust_analyzer は非掲載=自動有効化しない(rustaceanvimが管理)。
      automatic_enable = {
        "html",
        "lua_ls",
        "emmet_ls",
        "powershell_es",
        "basedpyright",
        "ruff",
        "biome",
        "ts_ls",
        "bashls",
        "intelephense",
        "prismals",
        "yamlls",
      },
    }

    mason_tool_installer.setup {
      ensure_installed = {
        "prettier",
        "stylua",
        "shfmt",
        "beautysh",
        "php-cs-fixer",
        "blade-formatter",
        "sql-formatter",
        "mypy", -- Python型チェック
      },
    }
  end,
}
