#!/usr/bin/env bash
# Codex CLI の `notify` から呼ばれるアダプタ。Codex はイベント発生時にこのスクリプトを
# 実行し、末尾の引数($1)にイベント内容の JSON を渡す。その type を見て通知音を鳴らす。
#
# Codex には Claude Code の Notification(許可待ち)に相当する汎用イベントが無いため、
# ここで扱うのは完了系(agent-turn-complete)のみ = 完了音を鳴らす。それ以外は無音。
set -eu

payload="${1:-}"
script_dir="$(cd "$(dirname "$0")" && pwd)"

# JSON の type を取り出す(python3 が無い/パース失敗時は空文字)。
event_type=""
if command -v python3 >/dev/null 2>&1; then
  event_type="$(
    printf '%s' "$payload" | python3 -c \
      'import sys, json
try:
    print(json.load(sys.stdin).get("type", ""))
except Exception:
    print("")' 2>/dev/null || true
  )"
fi

case "$event_type" in
  agent-turn-complete) exec "$script_dir/play.sh" stop ;;
  *) exit 0 ;;
esac
