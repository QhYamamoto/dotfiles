local M = {}

M.keys = {
  {
    "<LEADER>cx",
    function()
      require("core.codex_panel").toggle()
    end,
    desc = "Toggle Codex",
  },
  {
    "<LEADER>cr",
    function()
      require("core.codex_resume").resume_last()
    end,
    desc = "Resume last Codex session",
  },
}

M.opts = {
  toggle = nil,
  quit = "<C-q>",
}

return M
