return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",
  },
  config = function()
    local cmp = require "cmp"

    local luasnip = require "luasnip"

    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup {
      completion = {
        completeopt = "menu,menuone,preview,noselect",
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ["<C-h>"] = cmp.mapping.scroll_docs(-4),
        ["<C-n>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm { select = false },
        ["<Tab>"] = function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end,
        ["<S-Tab>"] = function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end,
      },
      sources = cmp.config.sources {
        { name = "nvim_lsp", priority = 1000 },
        { name = "luasnip", priority = 750 },
        { name = "supermaven", priority = 500 },
        { name = "buffer", priority = 250 },
        { name = "path", priority = 200 },
      },
    }

    local keymap = vim.keymap
    keymap.set({ "i", "s" }, "<Tab>", function()
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", true)
      end
    end, { silent = true })

    keymap.set({ "i", "s" }, "<S-Tab>", function()
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CMD><<CR>", true, false, true), "n", true)
      end
    end, { silent = true })
  end,
}
