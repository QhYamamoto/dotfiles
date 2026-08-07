return {
  "akinsho/toggleterm.nvim",
  config = function()
    local plugin_keymaps = require("core.keymaps.plugins").toggleterm
    local toggleterm = require "toggleterm"
    toggleterm.setup {
      size = 20,
      -- open_mapping = { "<M-t>" },
      -- 行番号の表示可否は on_open で term.numbers を見て一元管理するため、
      -- toggleterm自身の一律制御(hide_numbers)はオフにする。
      hide_numbers = false,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = false,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "double",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
      -- vim-tmux-navigatorがterminalモードのCtrl-h/j/k/lを横取りしないよう
      -- toggletermバッファではキーをそのままターミナルに送る
      on_open = function(term)
        local opts = { buffer = term.bufnr, noremap = true, silent = true }
        vim.keymap.set("t", "<C-h>", "<C-h>", opts)
        vim.keymap.set("t", "<C-j>", "<C-j>", opts)
        vim.keymap.set("t", "<C-k>", "<C-k>", opts)
        vim.keymap.set("t", "<C-l>", "<C-l>", opts)
        -- 行番号は既定で表示し、register_tool で numbers = false を指定したツール
        -- (lazygit等のTUI)だけ非表示にする。<M-t>の素シェルは numbers 未指定なので表示。
        -- グローバルTermOpen(core/autocmds)はtoggleterm端末を除外しているので、
        -- toggleterm端末の行番号はここが唯一の制御点になる。
        vim.wo.relativenumber = term.numbers ~= false
      end,
    }

    -- lazygitのフロートからファイルを開くときに呼ばれる。
    -- lazygit設定(os.edit)が --remote-expr 経由でこの関数を呼ぶ。
    -- フロート(=カレントウィンドウ)に開くと既存レイアウトに覆いかぶさるため、
    -- フロートを閉じてから背後の通常ウィンドウでファイルを開く。
    -- filenameはlazygitのシェルクオートを避けるためbase64で受け取る。
    function _G.lazygit_open(file_b64, line)
      vim.schedule(function()
        local ok, file = pcall(vim.base64.decode, file_b64)
        if not ok or not file or file == "" then
          return
        end
        -- lazygitのフロート(terminalバッファのフローティングウィンドウ)を閉じる
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local cfg = vim.api.nvim_win_get_config(win)
          if cfg.relative ~= "" then
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "terminal" then
              pcall(vim.api.nvim_win_close, win, false)
            end
          end
        end
        -- 背後の通常ウィンドウでファイルを開く
        vim.cmd("edit " .. vim.fn.fnameescape(file))
        if line and line > 0 then
          pcall(vim.api.nvim_win_set_cursor, 0, { line, 0 })
        end
      end)
      return ""
    end

    -- 行番号は既定で表示。numbers = false にするとそのツールだけ非表示にする。
    plugin_keymaps.register_tool("lazygit", {
      cmd = "lazygit",
      hidden = true,
      direction = "float",
      numbers = false,
    })

    plugin_keymaps.register_tool("lazydocker", {
      cmd = "lazydocker",
      hidden = true,
      direction = "float",
      numbers = false,
    })

    plugin_keymaps.register_tool("lazysql", {
      cmd = "lazysql",
      hidden = true,
      direction = "float",
      numbers = false,
    })

    -- Claude Squad: 同一リポジトリで複数のAIエージェント(Claude Code等)を
    -- git worktree + tmux セッションごとに並行管理するTUI。一覧・プレビュー・diffの
    -- 3ペイン構成なので、他のツールより大きめのフロートを割り当てる(float_optsは
    -- グローバル設定にkeepマージされるのでwidth/heightだけ上書きする)。
    -- 各エージェントはcs管理下のtmuxセッション+デーモンで常駐するため、このフロートを
    -- 閉じてもバックグラウンドで走り続け、再度開くと復帰できる。
    plugin_keymaps.register_tool("claude-squad", {
      cmd = "cs",
      hidden = true,
      direction = "float",
      numbers = false,
      float_opts = {
        width = function()
          return math.floor(vim.o.columns * 0.9)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.9)
        end,
      },
    })

    plugin_keymaps.setup()
  end,
}
