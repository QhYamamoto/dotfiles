-- vim options
local opt = vim.opt

opt.title = true
opt.relativenumber = true
opt.number = true

-- tabs & indention
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.list = true   -- make all white chars visible
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

opt.whichwrap:append {
  ["<"] = true,
  [">"] = true,
  ["["] = true,
  ["]"] = true,
}
