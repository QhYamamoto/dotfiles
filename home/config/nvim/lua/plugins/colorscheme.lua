return {
  "sainnhe/everforest",
  priority = 1000,
  config = function()
    -- 視認性重視でhard(高コントラスト)にし、ターミナル側の透過を活かす。
    vim.g.everforest_background = "hard"
    vim.g.everforest_transparent_background = 1
    vim.g.everforest_better_performance = 1
    vim.o.background = "dark"
    vim.cmd.colorscheme "everforest"

    -- 関数の仮引数(外部から渡る変数)を通常の変数と色で区別する。素のeverforestでは
    -- 変数も仮引数も同じfg色(#d3c6aa)で見分けられないため、仮引数だけアクセント色に
    -- する。「この変数は自分で宣言したものか、渡されたものか」を一目で判別するための
    -- 意図的な上書き。treesitter(@variable.parameter)とLSPセマンティック
    -- (@lsp.type.parameter)の両方を上書きし、LSP有無に関わらず一貫させる。
    local parameter_hl = { fg = "#e69875" } -- everforest orange
    vim.api.nvim_set_hl(0, "@variable.parameter", parameter_hl)
    vim.api.nvim_set_hl(0, "@lsp.type.parameter", parameter_hl)

    -- グローバルステータスライン化で分割の境界がステータスラインで区切られなくなるため、
    -- WinSeparatorを素のグレーより明るくして分割境界を視認しやすくする。透過を維持したいので
    -- 背景はnoneのまま。
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#9da9a0", bg = "none" })

    -- 配色ではなく診断の表示挙動の設定なので維持する。
    vim.diagnostic.config {
      underline = true,
      signs = true,
      update_in_insert = false,
    }
  end,
}
