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
        "cssls",
        "lua_ls",
        "emmet_ls",
        "powershell_es",
        "pyright",
        "bashls",
        "volar",
        "prismals",
        "yamlls",
        "rust_analyzer",
      },

      automatic_installation = true,
    }

    mason_tool_installer.setup {
      ensure_installed = {
        "prettier",
        "stylua",
        "autopep8",
        "eslint_d",
        "shfmt",
        "beautysh",
        "php-cs-fixer",
        "blade-formatter",
        "sql-formatter",
      },
    }
  end,
}
