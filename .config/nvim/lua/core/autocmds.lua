-- register autocmds
vim.api.nvim_create_augroup("lua", {})

vim.api.nvim_create_autocmd({
  "InsertLeave",
  "CmdlineLeave",
}, {
  group = "lua",
  callback = function()
    local home = os.getenv("HOME")
    local script_path = home .. "/.config/nvim/zenhan/zenhan.sh"

    local uv = vim.loop
    uv.spawn("bash", {
      args = { script_path },
      stdio = { nil, nil, nil },
    })
  end,
})
