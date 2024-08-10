return {
  "romgrk/barbar.nvim",
  dependencies = {
    "lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
    "nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
  },
  init = function()
    vim.g.barbar_auto_setup = false

    local keymap = vim.keymap
    local opts = function(desc)
      return { desc = desc, silent = true }
    end
    -- scripts to restore last closed buffer
    local last_closed_buffer_num = nil
    local last_closed_buffer_path = nil

    local function on_buf_delete(args)
      local buf = args.buf
      if vim.api.nvim_buf_is_valid(buf) then
        last_closed_buffer_num = buf
        last_closed_buffer_path = vim.api.nvim_buf_get_name(buf)
      end
    end

    vim.api.nvim_create_autocmd("BufDelete", {
      callback = on_buf_delete,
    })

    local function restore_last_closed_buffer()
      if last_closed_buffer_num and vim.api.nvim_buf_is_valid(last_closed_buffer_num) then
        vim.cmd("badd " .. last_closed_buffer_path)
        vim.cmd("buffer " .. last_closed_buffer_num)
        last_closed_buffer_num = nil
        last_closed_buffer_path = nil
      else
        print "No buffer to restore"
      end
    end

    -- custom keymaps
    keymap.set(
      "n",
      "<LEADER>br",
      restore_last_closed_buffer,
      { desc = "restore last closed buffer", noremap = true, silent = true }
    )

    keymap.set("n", "<A-h>", "<Cmd>BufferPrevious<CR>", opts "Go to previous buffer")
    keymap.set("n", "<A-s>", "<Cmd>BufferPrevious<CR>", opts "Go to previous buffer")
    keymap.set("n", "<A-l>", "<Cmd>BufferNext<CR>", opts "Go to next buffer")
    keymap.set("n", "<A-g>", "<Cmd>BufferNext<CR>", opts "Go to next buffer")

    keymap.set("n", "<LEADER>1", "<Cmd>BufferGoto 1<CR>", opts "Go to buffer 1")
    keymap.set("n", "<LEADER>2", "<Cmd>BufferGoto 2<CR>", opts "Go to buffer 2")
    keymap.set("n", "<LEADER>3", "<Cmd>BufferGoto 3<CR>", opts "Go to buffer 3")
    keymap.set("n", "<LEADER>4", "<Cmd>BufferGoto 4<CR>", opts "Go to buffer 4")
    keymap.set("n", "<LEADER>5", "<Cmd>BufferGoto 5<CR>", opts "Go to buffer 5")
    keymap.set("n", "<LEADER>6", "<Cmd>BufferGoto 6<CR>", opts "Go to buffer 6")
    keymap.set("n", "<LEADER>7", "<Cmd>BufferGoto 7<CR>", opts "Go to buffer 7")
    keymap.set("n", "<LEADER>8", "<Cmd>BufferGoto 8<CR>", opts "Go to buffer 8")
    keymap.set("n", "<LEADER>9", "<Cmd>BufferGoto 9<CR>", opts "Go to buffer 9")
    keymap.set("n", "<LEADER>0", "<Cmd>BufferLast<CR>", opts "Go to last buffer")
  end,
  opts = {
    icons = {
      buffer_index = true,
    },
  },
  version = "^1.0.0", -- optional: only update when a new 1.x version is released
}
