return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  run = ":TSUpdate",
  config = function()
    local parser_install_dir = nil
    local is_headless = #vim.api.nvim_list_uis() == 0
    local ensure_installed = {
      "json",
      "javascript",
      "jsdoc",
      "typescript",
      "tsx",
      "yaml",
      "html",
      "css",
      "prisma",
      "markdown",
      "markdown_inline",
      "svelte",
      "graphql",
      "bash",
      "lua",
      "vim",
      "dockerfile",
      "gitignore",
      "query",
      "vimdoc",
      "c",
      "vue",
      "php",
      "powershell",
      "sql",
      "python",
      "rust",
    }
    if is_headless then
      parser_install_dir = "/tmp/nvim-treesitter-parsers"
      vim.fn.mkdir(parser_install_dir, "p")
      vim.opt.runtimepath:append(parser_install_dir)
      ensure_installed = {}
    end

    vim.treesitter.language.register("bash", "zsh")
    -- import nvim-treesitter plugin
    local treesitter = require "nvim-treesitter.configs"

    -- configure treesitter
    treesitter.setup { -- enable syntax highlighting
      modules = {},
      sync_install = false,
      auto_install = false,
      parser_install_dir = parser_install_dir,
      ignore_install = {},
      highlight = {
        enable = true,
      },
      -- enable indentation
      indent = { enable = true },
      -- ensure these language parsers are installed
      ensure_installed = ensure_installed,
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-m>",
          node_incremental = "<C-m>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    }

    -- autotag
    local autotag = require "nvim-ts-autotag"
    autotag.setup {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
      },
    }
  end,
}
