-- Claude Squad のエージェントセッションの内容(Claudeとの会話)を、tmux から
-- 吸い出して Neovim のバッファに開くためのモジュール。
--
-- 目的: cs にアタッチしたまま tmux コピーモードで会話をコピーしようとすると、
--   WezTerm → tmux → nvim(:terminal)→ cs → tmux という入れ子になり、
--   OSC52 が nvim の埋め込み端末を越えられずシステムクリップボードに届かない。
--   また WezTerm のコピーモードだと画面表示分しか取れず Claude 枠外も混ざる。
--   代わりにエージェントの tmux ペインを capture-pane で丸ごと取得して通常の
--   バッファに落とせば、nvim のモーション/選択/ヤンクがそのまま使え、コピーも
--   nvim の clipboard 経路(WSL は clip.exe 直叩き=入れ子と無関係)で確実に届く。
--
-- 取得はスナップショット(実行時点の内容)。コピー中に中身が動くと選択がズレて
-- 邪魔なので、あえて自動更新はしない。最新化したいときは <LEADER>lC の再実行、
-- またはキャプチャバッファ内で R を押すと同じバッファを開き直して差し替える。
--
-- 前提: cs はエージェントを同一 tmux サーバー上の "claudesquad_<名前>" という
--   セッションで動かす("claudesquad_term_<名前>" は cs 内のターミナルタブ)。

local M = {}

-- 会話本体のセッション(claudesquad_*)を列挙する。ターミナルタブ
-- (claudesquad_term_*)は会話ではないので除外する。
local function list_agent_sessions()
  local out = vim.fn.systemlist { "tmux", "list-sessions", "-F", "#{session_name}" }
  if vim.v.shell_error ~= 0 then
    return nil
  end
  local sessions = {}
  for _, name in ipairs(out) do
    if name:match "^claudesquad_" and not name:match "^claudesquad_term_" then
      table.insert(sessions, name)
    end
  end
  return sessions
end

-- 指定セッションのスクロールバックを取得し、整形して行配列で返す。失敗時は nil。
local function capture_lines(session)
  -- -p: 標準出力へ / -J: tmux の折返しを1行に結合 / -S -100000: 全スクロールバック
  local lines = vim.fn.systemlist {
    "tmux",
    "capture-pane",
    "-p",
    "-J",
    "-S",
    "-100000",
    "-t",
    session,
  }
  if vim.v.shell_error ~= 0 then
    return nil
  end
  -- capture はペイン幅まで空白で右パディングするので行末空白を除去し、
  -- 入力欄下の空行(ペイン高さ分)も末尾から削る。
  for i, line in ipairs(lines) do
    lines[i] = line:gsub("%s+$", "")
  end
  while #lines > 0 and lines[#lines] == "" do
    table.remove(lines)
  end
  return lines
end

local function buf_name_for(session)
  return "claude-squad://" .. session
end

local function find_buf_by_name(name)
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(b) and vim.api.nvim_buf_get_name(b) == name then
      return b
    end
  end
  return nil
end

-- open_capture は R キーマップのコールバックから自分自身を呼ぶので前方宣言する。
local open_capture

-- 指定セッション用のバッファを「必ず正しい状態」で用意する。既存があれば再利用し、
-- 無ければ作る。オプションと R キーマップは開くたびに毎回適用する。こうしておくと、
-- ウィンドウを閉じて開き直した際にバッファローカルキーマップが失われるようなエッジ
-- ケースでも、開き直しで必ず R が復活する(reuse時に付け直さない不具合を防ぐ)。
local function ensure_buf(session, lines)
  local name = buf_name_for(session)
  local buf = find_buf_by_name(name)
  if buf == nil then
    buf = vim.api.nvim_create_buf(false, true) -- unlisted scratch
    pcall(vim.api.nvim_buf_set_name, buf, name)
  end

  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "hide"
  vim.bo[buf].filetype = "markdown" -- Claudeの出力はmarkdown寄りなので見やすい

  -- R = 再キャプチャ(同セッションを開き直して差し替え)。毎回付け直す。
  vim.keymap.set("n", "R", function()
    open_capture(session)
  end, { buffer = buf, silent = true, desc = "Claude Squad: refresh capture" })

  return buf
end

-- 指定セッションをキャプチャしてバッファに開く/更新する。
open_capture = function(session)
  local lines = capture_lines(session)
  if lines == nil then
    vim.notify("claude-squad: capture-pane に失敗しました (" .. session .. ")", vim.log.levels.ERROR)
    return
  end
  if #lines == 0 then
    vim.notify(
      "claude-squad: 取得できる内容がありませんでした (" .. session .. ")",
      vim.log.levels.WARN
    )
    return
  end

  local buf = ensure_buf(session, lines)

  -- 既に表示中ならそのウィンドウへ、無ければ新タブに開く。
  local wins = vim.fn.win_findbuf(buf)
  if #wins > 0 then
    vim.api.nvim_set_current_win(wins[1])
  else
    vim.cmd "tabnew"
    vim.api.nvim_win_set_buf(0, buf)
  end
  vim.cmd "normal! G" -- 最新(末尾)へ
end

-- エントリポイント。会話セッションが複数なら選択させる。
function M.capture()
  local sessions = list_agent_sessions()
  if sessions == nil then
    vim.notify("claude-squad: tmux サーバーに接続できませんでした", vim.log.levels.ERROR)
    return
  end
  if #sessions == 0 then
    vim.notify(
      "claude-squad: エージェントセッション(claudesquad_*)が見つかりません",
      vim.log.levels.WARN
    )
    return
  end
  if #sessions == 1 then
    open_capture(sessions[1])
    return
  end
  vim.ui.select(sessions, { prompt = "Capture するセッション:" }, function(choice)
    if choice then
      open_capture(choice)
    end
  end)
end

return M
