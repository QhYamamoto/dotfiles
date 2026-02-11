return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
    {
      "ray-x/lsp_signature.nvim",
      event = "InsertEnter",
      opts = {
        bind = true,
        handler_opts = {
          border = "rounded",
        },
      },
    },
  },
  config = function()
    local lspconfig = require "lspconfig"
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
          keymap.set("n", "gR", "<CMD>Telescope lsp_references<CR>", opts)

          opts.desc = "Go to declaration"
          keymap.set("n", "gd", vim.lsp.buf.declaration, opts)

          opts.desc = "Show LSP definitions"
          keymap.set("n", "<F12>", "<CMD>Telescope lsp_definitions<CR>", opts)

          opts.desc = "Show LSP implementations"
          keymap.set("n", "gi", "<CMD>Telescope lsp_implementations<CR>", opts)

          opts.desc = "Show LSP type definitions"
          keymap.set("n", "gt", "<CMD>Telescope lsp_type_definitions<CR>", opts)

          opts.desc = "See available code actions"
          keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

          opts.desc = "Smart rename"
          keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

          opts.desc = "Show buffer diagnostics"
          keymap.set("n", "<leader>D", "<CMD>Telescope diagnostics bufnr=0<CR>", opts)

          opts.desc = "Show line diagnostics"
          keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

          opts.desc = "Go to previous diagnostic"
          keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

          opts.desc = "Go to next diagnostic"
          keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

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
      vim.keymap.set("n", "<LEADER>oi", function()
        local params = {
          command = "_typescript.organizeImports",
          arguments = { vim.api.nvim_buf_get_name(0) },
          title = "typescript.organizeImports",
        }
        vim.lsp.buf.execute_command(params)
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

    -- Setup all mason-managed servers with shared capabilities + per-server overrides.
    local function setup_servers()
      mason_lspconfig.setup_handlers {
        function(server_name)
          local opts = vim.tbl_deep_extend("force", { capabilities = capabilities }, server_settings[server_name] or {})
          lspconfig[server_name].setup(opts)
        end,
        ["rust_analyzer"] = function() end,
      }
    end

    -- Register and setup the custom AutoHotkey v2 language server definition.
    local function setup_ahk2_server()
      -- FIXME: When opening an ahk file, the message `environment variable not found` is displayed.
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
          on_attach = function(_, _)
            require("lsp_signature").on_attach {
              bind = true,
              use_lspsaga = false,
              floating_window = true,
              fix_pos = true,
              hint_enable = true,
              hi_parameter = "Search",
              handler_opts = { "double" },
            }
          end,
        },
      }
      lspconfig["ahk2"].setup {}
    end

    -- Setup terraformls and run LSP formatting before writing tf/tfvars files.
    local function setup_terraform_server()
      lspconfig["terraformls"].setup {}
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
