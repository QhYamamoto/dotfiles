return {
  "mfussenegger/nvim-dap",
  dependencies = { "rcarriga/nvim-dap-ui" },
  config = function()
    require("core.keymaps.plugins").nvim_dap.setup()
  end,
}
