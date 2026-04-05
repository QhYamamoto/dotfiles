-- vim options
local opt = vim.opt
local is_headless = #vim.api.nvim_list_uis() == 0

if is_headless then
  opt.shadafile = "NONE"
end

opt.title = true
opt.relativenumber = true
opt.number = true

-- tabs & indention
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.list = true -- make all white chars visible
opt.listchars = { -- setting for each white chars
  tab = "|-",
  space = "･",
  trail = "･",
  eol = "↲",
  extends = "»",
  precedes = "«",
  nbsp = "%",
}

-- search settings
opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true

opt.termguicolors = true
opt.winblend = 0
opt.pumblend = 0

opt.clipboard:append "unnamedplus"

opt.splitright = true
opt.splitbelow = true
opt.foldenable = true
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldcolumn = "1"
opt.fillchars:append {
  foldopen = "",
  foldclose = "",
  foldsep = " ",
  fold = " ",
}

opt.whichwrap:append {
  ["<"] = true,
  [">"] = true,
  ["["] = true,
  ["]"] = true,
}

vim.api.nvim_create_augroup("DotfilesFoldLevel", { clear = true })
vim.api.nvim_create_autocmd({ "BufWinEnter", "BufWritePost" }, {
  group = "DotfilesFoldLevel",
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" then
      return
    end

    local winid = vim.fn.bufwinid(args.buf)
    if winid == -1 then
      return
    end

    vim.schedule(function()
      if vim.api.nvim_win_is_valid(winid) then
        vim.wo[winid].foldlevel = 99
      end
    end)
  end,
})
