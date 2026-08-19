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

    -- 走査量の上限。診断の組み立ては「行数 × 検出された誤り語数」で効くため、大きい
    -- バッファでは編集のたびに数百万回の文字列検索が走り、UI が固まる。上限を超えた
    -- バッファはスペルチェックを諦める(既存の診断は消す)。
    local MAX_LINES = 3000
    local MAX_BYTES = 512 * 1024

    -- 入力が止まってから走査するまでの待ち時間。打鍵ごとに全走査すると重いため。
    local DEBOUNCE_MS = 300

    local patterns_to_exclude = {
      "^#[0-9a-fA-F]{6}$", -- Hex color code
      "^[0-9a-fA-F-]{36}$", -- UUID
    }

    local function update_spelunker_diagnostics(bufnr)
      -- disable diagnostics on terminal
      local file_type = vim.bo[bufnr].buftype
      if file_type == "terminal" or file_type == "NvimTree" then
        return
      end

      local line_count = vim.api.nvim_buf_line_count(bufnr)
      local ok_offset, byte_size = pcall(vim.api.nvim_buf_get_offset, bufnr, line_count)
      if line_count > MAX_LINES or (ok_offset and byte_size > MAX_BYTES) then
        vim.diagnostic.reset(ns_id, bufnr)
        return
      end

      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

      local success, badword_list =
        pcall(vim.fn["spelunker#spellbad#get_spell_bad_list"], vim.fn["spelunker#get_buffer#all"]())
      if not success or not badword_list then
        return
      end

      local function should_ignore(word)
        for _, pattern in ipairs(patterns_to_exclude) do
          if word:match(pattern) then
            return true
          end
        end
        return false
      end

      local diagnostics = {}
      for lnum, line in ipairs(lines) do
        for _, badword in ipairs(badword_list) do
          if should_ignore(badword) then
            goto continue
          end

          local current_col = 1
          while true do
            local start_col, end_col = line:find(badword, current_col, true)
            if not start_col then
              break
            end

            table.insert(diagnostics, {
              lnum = lnum - 1,
              col = start_col - 1,
              end_col = end_col,
              severity = vim.diagnostic.severity.INFO,
              message = ("Misspelled word: '%s'"):format(badword),
              source = "spelunker",
            })

            current_col = end_col + 1
          end

          ::continue::
        end
      end

      vim.diagnostic.reset(ns_id, bufnr)
      vim.diagnostic.set(ns_id, bufnr, diagnostics)
    end

    local pending = 0

    vim.api.nvim_create_augroup("SpelunkerDiagnostics", { clear = true })
    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufEnter" }, {
      group = "SpelunkerDiagnostics",
      callback = function(args)
        pending = pending + 1
        local generation = pending
        local bufnr = args.buf
        vim.defer_fn(function()
          -- 待っている間に次の入力が来ていたら、その最後の1回に任せる。
          if generation ~= pending or not vim.api.nvim_buf_is_valid(bufnr) then
            return
          end
          update_spelunker_diagnostics(bufnr)
        end, DEBOUNCE_MS)
      end,
    })
  end,
}
