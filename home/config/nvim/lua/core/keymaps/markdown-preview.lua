-- Markdown プレビュー連携。プラグインではなく自前 Rust CLI（`dotfiles md-preview`）を
-- 叩いてブラウザプレビューを開閉する。CLI はフォアグラウンドで素早く結果を1行返し、実サーバは
-- バックグラウンドに残す作りなので、その1行を捉えて起動/停止を通知する。

local M = {}

-- shell alias `dtf` は jobstart から解決できないため実バイナリ名 `dotfiles`（PATH 上）で呼ぶ。
local function md_preview(extra_args)
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("MarkdownPreview: バッファにファイルパスがありません", vim.log.levels.WARN)
    return
  end

  local cmd = { "dotfiles", "md-preview", file }
  vim.list_extend(cmd, extra_args or {})

  local function collect(dst)
    return function(_, data)
      if not data then
        return
      end
      for _, line in ipairs(data) do
        if line ~= "" then
          table.insert(dst, line)
        end
      end
    end
  end

  local out, err = {}, {}
  local job = vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = collect(out),
    on_stderr = collect(err),
    on_exit = function(_, code)
      if code == 0 then
        local msg = table.concat(out, " ")
        vim.notify(msg ~= "" and msg or "MarkdownPreview: done", vim.log.levels.INFO)
      else
        local msg = table.concat(err, " ")
        vim.notify(
          "MarkdownPreview: 失敗" .. (msg ~= "" and (": " .. msg) or ""),
          vim.log.levels.ERROR
        )
      end
    end,
  })

  if job <= 0 then
    vim.notify("MarkdownPreview: 起動に失敗しました（dotfiles が PATH にあるか確認）", vim.log.levels.WARN)
  end
end

function M.setup()
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("md_preview", {}),
    pattern = { "markdown" },
    callback = function(ev)
      local opts = function(desc)
        return { buffer = ev.buf, noremap = true, silent = true, desc = desc }
      end
      vim.keymap.set("n", "<LEADER>mp", function()
        md_preview()
      end, opts "MarkdownPreview")
      vim.keymap.set("n", "<LEADER>mP", function()
        md_preview { "--stop" }
      end, opts "MarkdownPreviewStop")
    end,
  })
end

return M
