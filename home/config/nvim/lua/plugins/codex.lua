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
    {
      "<LEADER>cr",
      function()
        require("core.codex_resume").resume_last()
      end,
      mode = { "n", "t" },
      desc = "Resume last Codex session",
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
  config = function(_, opts)
    require("codex").setup(opts)

    vim.api.nvim_create_user_command("CodexResume", function()
      require("core.codex_resume").resume_picker()
    end, { desc = "Resume a previous Codex session" })

    vim.api.nvim_create_user_command("CodexResumeLast", function()
      require("core.codex_resume").resume_last()
    end, { desc = "Resume the most recent Codex session" })
  end,
}
