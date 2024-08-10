return {
  "jwalton512/vim-blade",
  config = function()
    vim.api.nvim_command "autocmd BufRead,BufNewFile *.blade.php set filetype=blade"
  end,
}
