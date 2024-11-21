return {
  "kamykn/spelunker.vim",
  dependencies = {
    "kamykn/popup-menu.nvim",
    init = function()
      vim.schedule(function()
        vim.cmd [[hi PmenuSel ctermfg=135 ctermbg=239 cterm=NONE guifg=#b26eff guibg=#4e4e4e gui=NONE]]
      end)
    end,
  },
  init = function()
    vim.opt.spell = false
  end,
  config = function()
    local ns_id = vim.api.nvim_create_namespace "spelunker_diagnostics"

    local function update_spelunker_diagnostics()
      local bufnr = vim.api.nvim_get_current_buf()

      -- disable diagnostics on terminal
      if vim.bo[bufnr].buftype == "terminal" then
        return
      end

      local diagnostics = {}
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

      local success, badword_list =
        pcall(vim.fn["spelunker#spellbad#get_spell_bad_list"], vim.fn["spelunker#get_buffer#all"]())
      if not success or not badword_list then
        return
      end

      for lnum, line in ipairs(lines) do
        for _, badword in ipairs(badword_list) do
          local current_col = 1
          while true do
            local start_col, end_col = line:find(badword, current_col, true)
            -- If badword isn't found, break.
            if not start_col then
              break
            end

            table.insert(diagnostics, {
              lnum = lnum - 1,
              end_lnum = lnum - 1,
              col = start_col - 1,
              end_col = end_col,
              severity = vim.diagnostic.severity.INFO,
              message = ("Misspelled word: '%s'"):format(badword),
              source = "spelunker",
            })

            current_col = end_col + 1
          end
        end
      end

      vim.diagnostic.reset(ns_id, bufnr)
      vim.diagnostic.set(ns_id, bufnr, diagnostics)
    end

    vim.api.nvim_create_augroup("SpelunkerDiagnostics", { clear = true })
    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufEnter" }, {
      group = "SpelunkerDiagnostics",
      callback = function()
        update_spelunker_diagnostics()
      end,
    })
  end,
}
