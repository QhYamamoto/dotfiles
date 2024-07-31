return {
  "neoclide/coc.nvim",
  branch = "release",
  config = function()
    function _G.check_back_space()
      local col = vim.fn.col(".") - 1
      return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
    end

    -- key bind
    vim.o.hidden = true
    vim.api.nvim_set_keymap("x", "<LEADER>f", "<Plug>(coc-format-selected)", { noremap = false })

    local keymap = vim.keymap
    local opts = { noremap = true, silent = true }

    -- <LEADER>d で定義元へジャンプ
    keymap.set("n", "<F12>", "<Plug>(coc-definition)", opts)
    keymap.set("n", "<M-right>", "<C-I>", opts)
    keymap.set("n", "<M-left>", "<C-o>", opts)

    -- <LEADER>h でドキュメント表示
    keymap.set("n", "<LEADER>gh", ':call CocAction("doHover")<CR>', opts)


    opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
    keymap.set("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()',
      opts)
    keymap.set("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

    -- Make <CR> to accept selected completion item or notify coc.nvim to format
    -- <C-g>u breaks current undo, please make your own choice
    keymap.set("i", "<C-n>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-n>"]], opts)

    -- Use `[g` and `]g` to navigate diagnostics
    -- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
    keymap.set("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
    keymap.set("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })

    -- Use K to show documentation in preview window
    function _G.show_docs()
      local cw = vim.fn.expand("<cword>")
      if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
        vim.api.nvim_command("h " .. cw)
      elseif vim.api.nvim_eval("coc#rpc#ready()") then
        vim.fn.CocActionAsync("doHover")
      else
        vim.api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
      end
    end

    keymap.set("n", "K", "<CMD>lua _G.show_docs()<CR>", { silent = true })

    vim.api.nvim_set_keymap("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "\\<C-f>"',
      { noremap = true, expr = true, nowait = true })

    vim.api.nvim_set_keymap("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "\\<C-b>"',
      { noremap = true, expr = true, nowait = true })

    vim.api.nvim_set_keymap("i", "<C-f>", 'coc#float#has_scroll() ? "\\<c-r>=coc#float#scroll(1)\\<CR>" : "\\<Right>"',
      { noremap = true, expr = true, nowait = true })

    vim.api.nvim_set_keymap("i", "<C-b>", 'coc#float#has_scroll() ? "\\<c-r>=coc#float#scroll(0)\\<CR>" : "\\<Left>"',
      { noremap = true, expr = true, nowait = true })

    -- color highlight
    vim.api.nvim_set_hl(0, "@parameter", { fg = 0x306b72 });
    vim.api.nvim_set_hl(0, "@type", { fg = 0x729de3 });
    vim.api.nvim_set_hl(0, "@function", { fg = 0xe5b124 });
    vim.api.nvim_set_hl(0, "@variable", { fg = 0x26cdca });
    vim.api.nvim_set_hl(0, "CocSemComment", { fg = 0x505050 });
    vim.api.nvim_set_hl(0, "CocSemClass", { fg = 0x729de3, bold = true });
    vim.api.nvim_set_hl(0, "CocSemEnum", { fg = 0x397797, bold = true });
    vim.api.nvim_set_hl(0, "CocSemEnumMember", { fg = 0x397797, bold = true });
    vim.api.nvim_set_hl(0, "CocSemStruct", { fg = 0x729de3 });
    vim.api.nvim_set_hl(0, "CocSemMethod", { fg = 0xe5b124, underline = true });
    vim.api.nvim_set_hl(0, "CocSemProperty", { fg = 0x7ca6b7, underline = true });
    vim.api.nvim_set_hl(0, "CocSemMacro", { fg = 0x8f5daf, bold = true });
    vim.api.nvim_set_hl(0, "CocSemNamespace", { fg = 0x00d780, bold = true });
    -- color for language server
    vim.api.nvim_set_hl(0, "CocSemDeprecated", { strikethrough = true });
    vim.api.nvim_set_hl(0, "CocUnusedHighlight", { strikethrough = true });
  end,
  opt = true,
  event = "BufEnter"
}
