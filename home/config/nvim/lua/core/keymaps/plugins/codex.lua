local M = {}

M.keys = {
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
}

M.opts = {
  toggle = nil,
  quit = "<C-q>",
}

return M
