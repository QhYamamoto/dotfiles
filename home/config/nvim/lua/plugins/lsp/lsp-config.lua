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
    local mason_lspconfig = require "mason-lspconfig"
    local cmp_nvim_lsp = require "cmp_nvim_lsp"

    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Register buffer-local LSP keymaps and enable inlay hints when supported.
    local function setup_lsp_attach_keymaps()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = plugin_keymaps.on_attach,
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

    local function directory_exists(path)
      local stat = vim.uv.fs_stat(path)
      return stat and stat.type == "directory"
    end

    local function file_contains(path, pattern)
      if vim.fn.filereadable(path) == 0 then
        return false
      end

      for _, line in ipairs(vim.fn.readfile(path, "", 60)) do
        if line:find(pattern) then
          return true
        end
      end

      return false
    end

    local function wordpress_root()
      local wp_includes = vim.fs.find("wp-includes", {
        path = vim.uv.cwd(),
        upward = true,
        type = "directory",
      })[1]

      if wp_includes then
        return vim.fs.dirname(wp_includes)
      end
    end

    local function is_wordpress_theme_project()
      local style_css = vim.uv.cwd() .. "/style.css"
      return file_contains(style_css, "^%s*%*?%s*Theme Name%s*:") and file_contains(style_css, "^%s*%*?%s*Template%s*:")
    end

    local function is_wordpress_project()
      return wordpress_root() ~= nil or is_wordpress_theme_project()
    end

    local function wordpress_include_paths()
      local paths = {}
      local wp_root = wordpress_root()

      if wp_root then
        local candidates = {
          wp_root,
          wp_root .. "/wp-admin",
          wp_root .. "/wp-includes",
          wp_root .. "/wp-content/plugins",
          wp_root .. "/wp-content/themes",
        }

        for _, path in ipairs(candidates) do
          if directory_exists(path) then
            table.insert(paths, path)
          end
        end
      end

      return paths
    end

    local function intelephense_stubs()
      local stubs = {
        "apache",
        "bcmath",
        "bz2",
        "calendar",
        "com_dotnet",
        "Core",
        "ctype",
        "curl",
        "date",
        "dba",
        "dom",
        "enchant",
        "exif",
        "FFI",
        "fileinfo",
        "filter",
        "fpm",
        "ftp",
        "gd",
        "gettext",
        "gmp",
        "hash",
        "iconv",
        "imap",
        "intl",
        "json",
        "ldap",
        "libxml",
        "mbstring",
        "meta",
        "mysqli",
        "oci8",
        "odbc",
        "openssl",
        "pcntl",
        "pcre",
        "PDO",
        "pgsql",
        "Phar",
        "posix",
        "pspell",
        "random",
        "readline",
        "Reflection",
        "session",
        "shmop",
        "SimpleXML",
        "snmp",
        "soap",
        "sockets",
        "sodium",
        "SPL",
        "sqlite3",
        "standard",
        "superglobals",
        "sysvmsg",
        "sysvsem",
        "sysvshm",
        "tidy",
        "tokenizer",
        "uri",
        "xml",
        "xmlreader",
        "xmlrpc",
        "xmlwriter",
        "xsl",
        "Zend OPcache",
        "zip",
        "zlib",
      }

      if is_wordpress_project() then
        table.insert(stubs, "wordpress")
      end

      return stubs
    end

    -- Add TypeScript-only utility mapping for organize imports.
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
      intelephense = {
        settings = {
          intelephense = {
            environment = {
              includePaths = wordpress_include_paths(),
            },
            stubs = intelephense_stubs(),
            telemetry = {
              enabled = false,
            },
          },
        },
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
        on_attach = plugin_keymaps.typescript_on_attach,
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
