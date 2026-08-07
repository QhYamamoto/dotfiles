return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    local plugin_keymaps = require("core.keymaps.plugins").lsp
    local cmp_nvim_lsp = require "cmp_nvim_lsp"

    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Register buffer-local LSP keymaps and enable inlay hints when supported.
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = plugin_keymaps.on_attach,
    })

    -- Add custom filetype detection used by language servers/formatters.
    vim.filetype.add {
      extension = {
        zsh = "zsh",
      },
    }

    -- Customize diagnostic gutter icons.
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- Neovim 0.12.0のバグ対策: rename応答のannotationIdを剥がす
    -- https://github.com/neovim/neovim/issues でannotated text editsの扱いが壊れている
    local orig_rename_handler = vim.lsp.handlers["textDocument/rename"]
    vim.lsp.handlers["textDocument/rename"] = function(err, result, ctx, config)
      if result then
        if result.documentChanges then
          for _, change in ipairs(result.documentChanges) do
            if change.edits then
              for _, edit in ipairs(change.edits) do
                edit.annotationId = nil
              end
            end
          end
        end
        if result.changes then
          for _, edits in pairs(result.changes) do
            for _, edit in ipairs(edits) do
              edit.annotationId = nil
            end
          end
        end
      end
      return orig_rename_handler(err, result, ctx, config)
    end

    -- mason-lspconfig 2.0 + Neovim 0.11+ の vim.lsp.config / vim.lsp.enable 方式。
    -- インストール済みサーバーは mason-lspconfig が自動でenableする(rust_analyzerは除外)。
    -- 以下は各サーバーのカスタム設定の上書き。共通のcapabilitiesは "*" で全体に付与する。
    vim.lsp.config("*", {
      capabilities = capabilities,
    })

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          completion = {
            callSnippet = "Replace",
          },
        },
      },
    })

    vim.lsp.config("emmet_ls", {
      filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
    })

    vim.lsp.config("bashls", {
      filetypes = { "sh", "bash", "zsh" },
    })

    vim.lsp.config("yamlls", {
      settings = {
        yaml = {
          schemas = {
            ["https://raw.githubusercontent.com/lalcebo/json-schema/master/serverless/reference.json"] = "serverless.yaml",
          },
        },
      },
      filetypes = { "yaml" },
    })

    vim.lsp.config("powershell_es", {
      bundle_path = vim.env.HOME,
    })

    vim.lsp.config("basedpyright", {
      settings = {
        basedpyright = {
          disableOrganizeImports = true, -- Using Ruff
          -- basedpyrightはpython.analysisを拾わず既定の厳格モードで型診断を出すため、
          -- basedpyright名前空間でtypeCheckingModeをoffにして型診断を止める(mypyに委譲)。
          analysis = {
            typeCheckingMode = "off",
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
          },
        },
        python = {
          analysis = {
            typeCheckingMode = "off", -- Using mypy
            extraPaths = {},
          },
        },
      },
      -- 診断を無効化（mypyに委譲）、定義ジャンプ等のLSP機能は維持
      on_attach = function(client, bufnr)
        -- push-based diagnostics（publishDiagnostics）を無効化
        client.handlers["textDocument/publishDiagnostics"] = function() end
        -- pull-based diagnostics (Neovim 0.11+) も無効化
        client.server_capabilities.diagnosticProvider = nil
        -- 既存の診断をクリア
        local ns = vim.lsp.diagnostic.get_namespace(client.id)
        vim.diagnostic.reset(ns, bufnr)
      end,
    })

    vim.lsp.config("ruff", {
      init_options = {
        settings = {
          organizeImports = true,
          codeAction = {
            fixViolation = {
              enable = false,
            },
          },
        },
      },
    })

    -- Disable Ruff hover in favor of Pyright.
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client ~= nil and client.name == "ruff" then
          client.server_capabilities.hoverProvider = false
        end
      end,
      desc = "LSP: Disable hover capability from Ruff",
    })

    -- Custom AutoHotkey v2 language server (mason管理外なので明示的に定義・有効化する)。
    vim.lsp.config("ahk2", {
      cmd = {
        "node",
        vim.fn.expand(vim.env.HOME .. "/vscode-autohotkey2-lsp/server/dist/server.js"),
        "--stdio",
      },
      filetypes = { "ahk", "autohotkey", "ah2" },
      root_markers = { ".git" },
      init_options = {
        locale = "en-us",
        InterpreterPath = "/mnt/c/Program Files/AutoHotkey/v2/AutoHotkey.exe",
      },
    })
    vim.lsp.enable "ahk2"

    -- terraformls (mason管理外。バイナリがPATHにあれば起動する)。
    vim.lsp.enable "terraformls"
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
      pattern = { "*.tf", "*.tfvars" },
      callback = function()
        vim.lsp.buf.format()
      end,
    })
  end,
}
