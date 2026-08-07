#!/bin/bash
# AIエージェントの「作業完了時などに通知音を鳴らす」設定を登録する。
# 音を鳴らすコアは agent-notify/play.sh に集約し、ここではツールごとの設定ファイルへ
# 冪等に登録するだけ。導入済みのツール(~/.claude / ~/.codex の有無で判定)にのみ設定し、
# どちらも無ければ何もしない。設定ファイルはツール本体が書き換えるため symlink はしない。
set -e

# リポジトリ内の絶対パスを、このスクリプト自身の位置から解決する。
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
NOTIFY_DIR="$REPO_ROOT/agent-notify"
PLAY="$NOTIFY_DIR/play.sh"
CODEX_ADAPTER="$NOTIFY_DIR/codex-notify.sh"

chmod +x "$PLAY" "$CODEX_ADAPTER" 2>/dev/null || true

# ---- Claude Code (~/.claude/settings.json の hooks) ----
CLAUDE_SETTINGS="$HOME/.claude/settings.json"
if [ -d "$HOME/.claude" ]; then
  if command -v python3 >/dev/null 2>&1; then
    CLAUDE_SETTINGS="$CLAUDE_SETTINGS" PLAY="$PLAY" python3 - <<'PY'
import json, os

path = os.environ["CLAUDE_SETTINGS"]
play = os.environ["PLAY"]

try:
    with open(path) as f:
        data = json.load(f)
except FileNotFoundError:
    data = {}
except json.JSONDecodeError:
    raise SystemExit(f"[agent_notify] {path} is not valid JSON; aborting to avoid clobbering it.")

hooks = data.setdefault("hooks", {})
wanted = {
    "Stop": f'"{play}" stop',            # 応答完了
    "Notification": f'"{play}" notification',  # 許可待ち・入力待ち
}

for event, cmd in wanted.items():
    groups = hooks.get(event, [])
    # 既存の自前エントリ(play.sh を指すもの)を除去してから付け直す = 冪等。
    # 他フックには触れない。
    groups = [
        g for g in groups
        if not any("agent-notify" in h.get("command", "") for h in g.get("hooks", []))
    ]
    groups.append({"hooks": [{"type": "command", "command": cmd}]})
    hooks[event] = groups

with open(path, "w") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write("\n")

print(f"[agent_notify] Claude Code hooks registered in {path}")
PY
  else
    echo "[agent_notify] python3 not found; skip Claude Code hooks." >&2
  fi
else
  echo "[agent_notify] ~/.claude not found; skip Claude Code hooks."
fi

# ---- Codex CLI (~/.codex/config.toml の notify) ----
CODEX_CONFIG="$HOME/.codex/config.toml"
if [ -d "$HOME/.codex" ]; then
  if command -v python3 >/dev/null 2>&1; then
    CODEX_CONFIG="$CODEX_CONFIG" CODEX_ADAPTER="$CODEX_ADAPTER" python3 - <<'PY'
import os, re

path = os.environ["CODEX_CONFIG"]
adapter = os.environ["CODEX_ADAPTER"]
# TOML 文字列内のバックスラッシュ/引用符をエスケープ(WSL パスに \ は出ないが安全側で)。
esc = adapter.replace("\\", "\\\\").replace('"', '\\"')
notify_line = f'notify = ["bash", "{esc}"]'

try:
    with open(path) as f:
        text = f.read()
except FileNotFoundError:
    text = ""

# 既存のトップレベル notify 行を除去し、ファイル先頭へ付け直す = 冪等。
# 先頭に置くのは、[table] より後ろに書くとその表のキー扱いになり壊れるのを避けるため。
lines = [l for l in text.splitlines() if not re.match(r"\s*notify\s*=", l)]
new_text = notify_line + "\n" + "\n".join(lines)
if not new_text.endswith("\n"):
    new_text += "\n"

os.makedirs(os.path.dirname(path), exist_ok=True)
with open(path, "w") as f:
    f.write(new_text)

print(f"[agent_notify] Codex notify registered in {path}")
PY
  else
    echo "[agent_notify] python3 not found; skip Codex notify." >&2
  fi
else
  echo "[agent_notify] ~/.codex not found; skip Codex notify."
fi
