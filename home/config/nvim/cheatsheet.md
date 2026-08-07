# Cheat Sheet

自分用のキー一覧。追記・修正はこの `cheatsheet.md` を直接編集する。

## Alacritty (ターミナル本体)

    Ctrl+Shift+C       選択範囲をコピー
    Ctrl+V             ペースト
    Ctrl+= / - / 0     フォント 拡大 / 縮小 / リセット
    Ctrl+Shift+F / B   スクロールバック検索 前方 / 後方
    Shift+PageUp/Down  スクロール(tmux の外にいるとき)
    Alt+Enter          全画面トグル
    Ctrl+Shift+V       vi モード開始(y=ヤンク / q=終了)

## tmux (タブ・分割はこちら)

    Ctrl+b  c          新規ウィンドウ(= タブ)
    Ctrl+b  n / p      次 / 前のタブ
    Ctrl+b  0-9 / w    番号で移動 / 一覧
    Ctrl+b  &          タブを閉じる
    Ctrl+b  h / v      上下 / 左右に分割
    Ctrl+h/j/k/l       ペイン間を移動(nvim とシームレス)
    Ctrl+b  x          ペインを閉じる
    Ctrl+b  [          コピーモード(q で抜ける)

## Neovim (自分用メモ)

    <leader>?          このチートシートを開く
    <leader>lC         Claude Squad の会話をバッファに取り込む
