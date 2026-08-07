return {
  "rhysd/conflict-marker.vim",
  "nvim-lua/plenary.nvim",
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    init = function()
      -- tmuxでズーム(Ctrl-b z)中は、Neovimの端でペイン境界を越えようとしても
      -- 隣のtmuxペインへ移動しない(=ズームを解除しない)。境界では無反応になる。
      vim.g.tmux_navigator_disable_when_zoomed = 1
      -- 既定マッピングを無効化し、下のkeysで明示的に張る(遅延ロードのため)。
      vim.g.tmux_navigator_no_mappings = 1
    end,
    keys = {
      {
        "<C-h>",
        function()
          vim.cmd.TmuxNavigateLeft()
        end,
        mode = "n",
      },
      {
        "<C-j>",
        function()
          vim.cmd.TmuxNavigateDown()
        end,
        mode = "n",
      },
      {
        "<C-k>",
        function()
          vim.cmd.TmuxNavigateUp()
        end,
        mode = "n",
      },
      {
        "<C-l>",
        function()
          vim.cmd.TmuxNavigateRight()
        end,
        mode = "n",
      },
      {
        "<C-\\>",
        function()
          vim.cmd.TmuxNavigatePrevious()
        end,
        mode = "n",
      },
    },
  },
  "mcauley-penney/tidy.nvim",
  "HiPhish/rainbow-delimiters.nvim",
  "andres-lowrie/vim-sqlx",
  {
    "aklt/plantuml-syntax",
    lazy = false,
  },
  "jidn/vim-dbml",
}
