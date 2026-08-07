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

    local function get_node_from_match(match, capture_id)
      local node_or_list = match[capture_id]
      if type(node_or_list) == "table" then
        return node_or_list[1]
      end
      return node_or_list
    end

    local html_script_type_languages = {
      ["text/javascript"] = "javascript",
      ["text/babel"] = "javascript",
      ["text/jsx"] = "javascriptreact",
      ["application/javascript"] = "javascript",
      ["application/ecmascript"] = "javascript",
    }

    local query = vim.treesitter.query
    local force_opts = { force = true, all = true }

    query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
      local node = get_node_from_match(match, pred[2])
      if not node then
        return
      end
      local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
      local configured = html_script_type_languages[type_attr_value]
      if configured then
        metadata["injection.language"] = configured
      else
        local parts = vim.split(type_attr_value, "/", {})
        metadata["injection.language"] = parts[#parts]
      end
    end, force_opts)

    query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
      local node = get_node_from_match(match, pred[2])
      if not node then
        return
      end
      metadata["injection.language"] = vim.treesitter.get_node_text(node, bufnr):lower()
    end, force_opts)

    query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
      local id = pred[2]
      local node = get_node_from_match(match, id)
      if not node then
        return
      end
      local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
      if not metadata[id] then
        metadata[id] = {}
      end
      metadata[id].text = string.lower(text)
    end, force_opts)

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
