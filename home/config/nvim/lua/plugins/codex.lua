return {
  "johnseth97/codex.nvim",
  cmd = { "Codex", "CodexToggle" },
  keys = {
    {
      "<LEADER>cx",
      function()
        require("codex").toggle()
      end,
      mode = { "n", "t" },
      desc = "Toggle Codex",
    },
  },
  opts = {
    keymaps = {
      toggle = nil,
      quit = "<C-q>",
    },
    border = "rounded",
    width = 0.8,
    height = 0.8,
    autoinstall = false,
    panel = true,
    use_buffer = false,
  },
}
