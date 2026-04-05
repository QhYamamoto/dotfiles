local set_maps = require("core.keymaps.plugins.util").set_maps

local M = {}

local state = {
  last_closed_buffer_num = nil,
  last_closed_buffer_path = nil,
}

function M.on_buf_delete(args)
  local buf = args.buf
  if vim.api.nvim_buf_is_valid(buf) then
    state.last_closed_buffer_num = buf
    state.last_closed_buffer_path = vim.api.nvim_buf_get_name(buf)
  end
end

function M.setup()
  local restore_last_closed_buffer = function()
    if state.last_closed_buffer_num and vim.api.nvim_buf_is_valid(state.last_closed_buffer_num) then
      vim.cmd("badd " .. state.last_closed_buffer_path)
      vim.cmd("buffer " .. state.last_closed_buffer_num)
      state.last_closed_buffer_num = nil
      state.last_closed_buffer_path = nil
    else
      print "No buffer to restore"
    end
  end

  set_maps {
    {
      mode = "n",
      lhs = "<LEADER>bR",
      rhs = restore_last_closed_buffer,
      desc = "restore last closed buffer",
      opts = { noremap = true, silent = true },
    },
    {
      mode = "n",
      lhs = "<A-h>",
      rhs = "<Cmd>BufferPrevious<CR>",
      desc = "Go to previous buffer",
      opts = { silent = true },
    },
    {
      mode = "n",
      lhs = "<A-s>",
      rhs = "<Cmd>BufferPrevious<CR>",
      desc = "Go to previous buffer",
      opts = { silent = true },
    },
    { mode = "n", lhs = "<A-l>", rhs = "<Cmd>BufferNext<CR>", desc = "Go to next buffer", opts = { silent = true } },
    { mode = "n", lhs = "<A-g>", rhs = "<Cmd>BufferNext<CR>", desc = "Go to next buffer", opts = { silent = true } },
    { mode = "n", lhs = "<LEADER>1", rhs = "<Cmd>BufferGoto 1<CR>", desc = "Go to buffer 1", opts = { silent = true } },
    { mode = "n", lhs = "<LEADER>2", rhs = "<Cmd>BufferGoto 2<CR>", desc = "Go to buffer 2", opts = { silent = true } },
    { mode = "n", lhs = "<LEADER>3", rhs = "<Cmd>BufferGoto 3<CR>", desc = "Go to buffer 3", opts = { silent = true } },
    { mode = "n", lhs = "<LEADER>4", rhs = "<Cmd>BufferGoto 4<CR>", desc = "Go to buffer 4", opts = { silent = true } },
    { mode = "n", lhs = "<LEADER>5", rhs = "<Cmd>BufferGoto 5<CR>", desc = "Go to buffer 5", opts = { silent = true } },
    { mode = "n", lhs = "<LEADER>6", rhs = "<Cmd>BufferGoto 6<CR>", desc = "Go to buffer 6", opts = { silent = true } },
    { mode = "n", lhs = "<LEADER>7", rhs = "<Cmd>BufferGoto 7<CR>", desc = "Go to buffer 7", opts = { silent = true } },
    { mode = "n", lhs = "<LEADER>8", rhs = "<Cmd>BufferGoto 8<CR>", desc = "Go to buffer 8", opts = { silent = true } },
    { mode = "n", lhs = "<LEADER>9", rhs = "<Cmd>BufferGoto 9<CR>", desc = "Go to buffer 9", opts = { silent = true } },
    {
      mode = "n",
      lhs = "<LEADER>0",
      rhs = "<Cmd>BufferLast<CR>",
      desc = "Go to last buffer",
      opts = { silent = true },
    },
    {
      mode = "n",
      lhs = "<Space>bn",
      rhs = "<Cmd>BufferOrderByName<CR>",
      desc = "Sort buffers by name",
      opts = { silent = true },
    },
  }
end

return M
