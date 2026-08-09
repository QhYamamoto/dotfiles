local set_maps = require("core.keymaps.plugins.util").set_maps

local M = {}

local image_extensions = {
  avif = true,
  bmp = true,
  gif = true,
  heic = true,
  jpeg = true,
  jpg = true,
  png = true,
  svg = true,
  tif = true,
  tiff = true,
  webp = true,
}

local function is_image_file(path)
  local extension = path:match "^.+%.([^./\\]+)$"
  return extension ~= nil and image_extensions[extension:lower()] == true
end

local function windows_path(path)
  if vim.fn.executable "wslpath" == 0 then
    return nil
  end

  local result = vim.fn.systemlist { "wslpath", "-w", path }
  if vim.v.shell_error ~= 0 or result[1] == nil or result[1] == "" then
    return nil
  end

  return result[1]
end

local function start_detached(cmd, path)
  local job = vim.fn.jobstart(cmd, { detach = true })
  if job <= 0 then
    vim.notify("Failed to open image: " .. path, vim.log.levels.WARN)
  end
end

local function open_external(path)
  if vim.fn.executable "wslview" == 1 then
    start_detached({ "wslview", path }, path)
    return
  end

  if (vim.fn.has "wsl" == 1 or vim.env.WSL_DISTRO_NAME ~= nil) and vim.fn.executable "explorer.exe" == 1 then
    start_detached({ "explorer.exe", windows_path(path) or path }, path)
    return
  end

  if (vim.fn.has "wsl" == 1 or vim.env.WSL_DISTRO_NAME ~= nil) and vim.fn.executable "powershell.exe" == 1 then
    start_detached(
      { "powershell.exe", "-NoProfile", "-Command", "Start-Process -LiteralPath $args[0]", windows_path(path) or path },
      path
    )
    return
  end

  if vim.fn.executable "xdg-open" == 1 then
    vim.fn.jobstart({ "xdg-open", path }, { detach = true })
    return
  end

  vim.notify("No external opener found for " .. path, vim.log.levels.WARN)
end

function M.setup()
  set_maps {
    { mode = "n", lhs = "<LEADER>ee", rhs = "<CMD>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
    {
      mode = "n",
      lhs = "<LEADER>ef",
      rhs = "<CMD>NvimTreeFindFileToggle<CR>",
      desc = "Toggle file explorer on current file",
    },
  }
end

function M.on_attach(bufnr)
  local api = require "nvim-tree.api"

  local opts = function(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)

  local function open_or_preview_image()
    local node = api.tree.get_node_under_cursor()
    local path = node and node.absolute_path
    if node ~= nil and node.type == "file" and path ~= nil and is_image_file(path) then
      open_external(path)
      return
    end

    api.node.open.edit()
  end

  vim.keymap.set("n", "l", open_or_preview_image, opts "Open")
  vim.keymap.set("n", "<CR>", open_or_preview_image, opts "Open")
  vim.keymap.set("n", "o", open_or_preview_image, opts "Open")
  vim.keymap.set("n", "<Right>", open_or_preview_image, opts "Open")
  vim.keymap.set("n", "h", api.node.navigate.parent_close, opts "Close Directory")
  vim.keymap.set("n", "<Left>", api.node.navigate.parent_close, opts "Close Directory")
end

return M
