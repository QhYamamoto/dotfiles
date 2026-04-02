return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    local mason_lspconfig = require "mason-lspconfig"
    local cmp_nvim_lsp = require "cmp_nvim_lsp"
    local keymap = vim.keymap

    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Register buffer-local LSP keymaps and enable inlay hints when supported.
    local function setup_lsp_attach_keymaps()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }

          opts.desc = "Show LSP references"
          keymap.set("n", "gR", vim.lsp.buf.references, opts)

          opts.desc = "Go to declaration"
          keymap.set("n", "gd", vim.lsp.buf.declaration, opts)

          opts.desc = "Show LSP definitions"
          keymap.set("n", "<F12>", vim.lsp.buf.definition, opts)

          opts.desc = "Show LSP implementations"
          keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

          opts.desc = "Show LSP type definitions"
          keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)

          opts.desc = "See available code actions"
          keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

          opts.desc = "Smart rename"
          keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

          opts.desc = "Show buffer diagnostics"
          keymap.set("n", "<leader>D", "<CMD>Telescope diagnostics bufnr=0<CR>", opts)

          opts.desc = "Show line diagnostics"
          keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

          opts.desc = "Go to previous diagnostic"
          keymap.set("n", "[d", function()
            vim.diagnostic.jump { count = -1, float = true }
          end, opts)

          opts.desc = "Go to next diagnostic"
          keymap.set("n", "]d", function()
            vim.diagnostic.jump { count = 1, float = true }
          end, opts)

          opts.desc = "Show documentation for what is under cursor"
          keymap.set("n", "K", vim.lsp.buf.hover, opts)

          opts.desc = "Restart LSP"
          keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client ~= nil and client.supports_method "textDocument/inlayHint" then
            vim.lsp.inlay_hint.enable()
          end
        end,
      })
    end

    -- Add custom filetype detection used by language servers/formatters.
    local function setup_extra_filetypes()
      vim.filetype.add {
        extension = {
          zsh = "zsh",
        },
      }
    end

    -- Customize diagnostic gutter icons.
    local function setup_diagnostic_signs()
      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end
    end

    -- Add TypeScript-only utility mapping for organize imports.
    local function setup_typescript_keymap(_, bufnr)
      local execute_workspace_command = function(params)
        local result = vim.lsp.buf_request_sync(bufnr, "workspace/executeCommand", params, 5000)
        return result ~= nil
      end

      vim.keymap.set("n", "<LEADER>oi", function()
        local params = {
          command = "_typescript.organizeImports",
          arguments = { vim.api.nvim_buf_get_name(0) },
          title = "typescript.organizeImports",
        }
        execute_workspace_command(params)
        vim.cmd "silent! write"
      end, { buffer = bufnr, noremap = true, silent = true })
    end

    local server_settings = {
      emmet_ls = {
        filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
      },
      lua_ls = {
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
      },
      bashls = {
        filetypes = { "sh", "bash", "zsh" },
      },
      yamlls = {
        settings = {
          yaml = {
            schemas = {
              ["https://raw.githubusercontent.com/lalcebo/json-schema/master/serverless/reference.json"] = "serverless.yaml",
            },
          },
        },
        filetypes = { "yaml" },
      },
      ts_ls = {
        on_attach = setup_typescript_keymap,
      },
      powershell_es = {
        bundle_path = vim.env.HOME,
      },
    }

    -- Register all mason-managed server configs, then enable them explicitly.
    local function setup_servers()
      local installed_servers = mason_lspconfig.get_installed_servers()

      for _, server_name in ipairs(installed_servers) do
        if server_name ~= "rust_analyzer" then
          local opts = vim.tbl_deep_extend("force", { capabilities = capabilities }, server_settings[server_name] or {})
          vim.lsp.config(server_name, opts)
          vim.lsp.enable(server_name)
        end
      end
    end

    -- Register and setup the custom AutoHotkey v2 language server definition.
    local function setup_ahk2_server()
      -- FIXME: When opening an ahk file, the message `environment variable not found` is displayed.
      local lspconfig = require "lspconfig"
      local configs = require "lspconfig.configs"
      configs["ahk2"] = {
        default_config = {
          autostart = true,
          cmd = {
            "node",
            vim.fn.expand(vim.env.HOME .. "/vscode-autohotkey2-lsp/server/dist/server.js"),
            "--stdio",
          },
          filetypes = { "ahk", "autohotkey", "ah2" },
          init_options = {
            locale = "en-us",
            InterpreterPath = "/mnt/c/Program Files/AutoHotkey/v2/AutoHotkey.exe",
          },
          single_file_support = true,
          flags = { debounce_text_changes = 500 },
          capabilities = capabilities,
        },
      }
      vim.lsp.enable "ahk2"
    end

    -- Setup terraformls and run LSP formatting before writing tf/tfvars files.
    local function setup_terraform_server()
      vim.lsp.config("terraformls", {
        capabilities = capabilities,
      })
      vim.lsp.enable "terraformls"
      vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        pattern = { "*.tf", "*.tfvars" },
        callback = function()
          vim.lsp.buf.format()
        end,
      })
    end

    setup_lsp_attach_keymaps()
    setup_extra_filetypes()
    setup_diagnostic_signs()
    setup_servers()
    setup_ahk2_server()
    setup_terraform_server()
  end,
}
