-- register autocmds
vim.api.nvim_create_augroup("lua", {})

vim.api.nvim_create_autocmd({
  "InsertLeave",
  "CmdlineLeave",
}, {
  group = "lua",
  callback = function ()
    local home = os.getenv "HOME"
    local script_path = home .. "/.zenhan.zsh"

    local uv = vim.loop
    uv.spawn("zsh", {
      args = { script_path },
      stdio = { nil, nil, nil },
    })
  end,
})
