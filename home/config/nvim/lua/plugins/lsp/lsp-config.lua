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
    -- import lspconfig plugin
    local lspconfig = require "lspconfig"

    -- import mason_lspconfig plugin
    local mason_lspconfig = require "mason-lspconfig"

    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require "cmp_nvim_lsp"

    local keymap = vim.keymap -- for conciseness

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        -- set keybinds
        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<CMD>Telescope lsp_references<CR>", opts)

        opts.desc = "Go to declaration"
        keymap.set("n", "gd", vim.lsp.buf.declaration, opts)

        opts.desc = "Show LSP definitions"
        keymap.set("n", "<F12>", "<CMD>Telescope lsp_definitions<CR>", opts)
        keymap.set("n", "<M-Right>", "<C-I>", opts)
        keymap.set("n", "<M-Left>", "<C-o>", opts)

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

        -- inlay hint
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client ~= nil then
          if client.supports_method "textDocument/inlayHint" then
            vim.lsp.inlay_hint.enable()
          end
        end
      end,
    })

    vim.filetype.add {
      extension = {
        zsh = "zsh",
      },
    }

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    mason_lspconfig.setup_handlers {
      -- default handler for installed servers
      function(server_name)
        lspconfig[server_name].setup {
          capabilities = capabilities,
        }
      end,
      ["emmet_ls"] = function()
        -- configure emmet language server
        lspconfig["emmet_ls"].setup {
          capabilities = capabilities,
          filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
        }
      end,
      ["lua_ls"] = function()
        -- configure lua server (with special settings)
        lspconfig["lua_ls"].setup {
          capabilities = capabilities,
          settings = {
            Lua = {
              -- make the language server recognize "vim" global
              diagnostics = {
                globals = { "vim" },
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        }
      end,
      ["bashls"] = function()
        -- configure shell server
        lspconfig["bashls"].setup {
          capabilities = capabilities,
          filetypes = { "sh", "bash", "zsh" },
        }
      end,
      ["volar"] = function()
        lspconfig["volar"].setup {
          capabilities = capabilities,
          filetypes = { "vue", "javascript", "typescript", "javascriptreact", "typescriptreact" },
          init_options = {
            vue = {
              hybridMode = false,
            },
            typescript = {
              tsdk = vim.env.HOME .. "/node_modules/typescript/lib",
            },
          },
          cmd = {
            "/usr/local/bin/vue-language-server",
            "--stdio",
          },
        }
      end,
      ["yamlls"] = function()
        lspconfig["yamlls"].setup {
          capabilities = capabilities,
          settings = {
            yaml = {
              schemas = {
                ["https://raw.githubusercontent.com/lalcebo/json-schema/master/serverless/reference.json"] = "serverless.yaml",
              },
            },
          },
          filetypes = { "yaml" },
        }
      end,
      ["ts_ls"] = function()
        lspconfig["ts_ls"].setup {
          capabilities = capabilities,
          on_attach = function(_, bufnr)
            vim.keymap.set("n", "<LEADER>oi", function()
              local params = {
                command = "_typescript.organizeImports",
                arguments = { vim.api.nvim_buf_get_name(0) },
                title = "typescript.organizeImports",
              }
              vim.lsp.buf.execute_command(params)
              vim.cmd "silent! write"
            end, { buffer = bufnr, noremap = true, silent = true })
          end,
        }
      end,
      ["powershell_es"] = function()
        lspconfig["powershell_es"].setup {
          capabilities = capabilities,
          bundle_path = vim.env.HOME,
        }
      end,
      ["rust_analyzer"] = function() end,
    }

    -- settings of lsp for ahk
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

    -- settings for terraform-ls
    lspconfig["terraformls"].setup {}
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
      pattern = { "*.tf", "*.tfvars" },
      callback = function()
        vim.lsp.buf.format()
      end,
    })
  end,
}
