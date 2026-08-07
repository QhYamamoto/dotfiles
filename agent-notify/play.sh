#!/usr/bin/env bash
# AIエージェント(Claude Code / Codex 等)の通知音を鳴らす共通スクリプト。
# WSL 環境専用: 同梱 wav を wslpath で Windows パスへ変換し、powershell.exe の
# SoundPlayer で再生する。エージェント側の登録方法(Claude=hooks / Codex=notify)は
# それぞれのアダプタが担い、鳴らす処理はここに集約する。
#
# 使い方: play.sh <event>
#   event は sounds/<event>.wav に対応する(例: stop / notification)。
#   該当 wav が無い場合は stop.wav にフォールバックする。
#
# 音源の差し替え: sounds/<event>.wav を好きな wav に置き換えるだけでよい。
set -eu

event="${1:-stop}"
script_dir="$(cd "$(dirname "$0")" && pwd)"
wav="$script_dir/sounds/${event}.wav"

# 未知イベントは完了音にフォールバック。
if [ ! -f "$wav" ]; then
  wav="$script_dir/sounds/stop.wav"
fi

# Windows 音源が使えない環境(powershell.exe / wslpath 不在)や wav 欠如では黙って終了。
# 通知はあくまで副作用なので、エージェント本体の処理を妨げないよう常に成功で返す。
command -v powershell.exe >/dev/null 2>&1 || exit 0
command -v wslpath >/dev/null 2>&1 || exit 0
[ -f "$wav" ] || exit 0

win_wav="$(wslpath -w "$wav")"

# バックグラウンドで再生し即座に返す。PlaySync で最後まで鳴らしつつ、& で切り離すことで
# フック/notify 呼び出し側をブロックしない(再生完了を待たせない)。
(
  powershell.exe -NoProfile -Command \
    "(New-Object Media.SoundPlayer '${win_wav}').PlaySync()" >/dev/null 2>&1
) &

exit 0
