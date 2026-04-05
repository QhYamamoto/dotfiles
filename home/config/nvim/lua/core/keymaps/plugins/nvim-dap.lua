local set_maps = require("core.keymaps.plugins.util").set_maps

local M = {}

function M.setup()
  set_maps {
    { mode = "n", lhs = "<Leader>dl", rhs = "<cmd>lua require'dap'.step_into()<CR>", desc = "Debugger step into" },
    { mode = "n", lhs = "<Leader>dj", rhs = "<cmd>lua require'dap'.step_over()<CR>", desc = "Debugger step over" },
    { mode = "n", lhs = "<Leader>dk", rhs = "<cmd>lua require'dap'.step_out()<CR>", desc = "Debugger step out" },
    { mode = "n", lhs = "<Leader>dc", rhs = "<cmd>lua require'dap'.continue()<CR>", desc = "Debugger continue" },
    {
      mode = "n",
      lhs = "<Leader>db",
      rhs = "<cmd>lua require'dap'.toggle_breakpoint()<CR>",
      desc = "Debugger toggle breakpoint",
    },
    {
      mode = "n",
      lhs = "<Leader>dd",
      rhs = "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
      desc = "Debugger set conditional breakpoint",
    },
    { mode = "n", lhs = "<Leader>de", rhs = "<cmd>lua require'dap'.terminate()<CR>", desc = "Debugger reset" },
    { mode = "n", lhs = "<Leader>dr", rhs = "<cmd>lua require'dap'.run_last()<CR>", desc = "Debugger run last" },
    { mode = "n", lhs = "<Leader>dt", rhs = "<cmd>lua vim.cmd('RustLsp testables')<CR>", desc = "Debugger testables" },
  }
end

return M
