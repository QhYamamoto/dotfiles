local set_maps = require("core.keymaps.plugins.util").set_maps

local M = {}

local toggleterm_tools = {}
local toggleterm_tool_count = 0

local function get_opened_tui_tool()
  local result = nil
  foreach(toggleterm_tools, function(tui_tool, _)
    if tui_tool:is_open() then
      result = tui_tool
    end
  end)
  return result
end

function M.register_tool(label, settings)
  settings.count = 1000 + toggleterm_tool_count
  toggleterm_tool_count = toggleterm_tool_count + 1
  local Terminal = require("toggleterm.terminal").Terminal
  local tui_tool = Terminal:new(settings)
  toggleterm_tools[label] = tui_tool
end

function M.toggle_tool(label)
  local tui_tool = toggleterm_tools[label]
  if not tui_tool then
    return
  end

  local is_open = tui_tool:is_open()
  if not is_open then
    local opened_tui_tool = get_opened_tui_tool()
    if opened_tui_tool then
      opened_tui_tool:toggle()
    end
  end

  tui_tool:toggle()
  is_open = not is_open
  vim.defer_fn(function()
    if is_open then
      vim.api.nvim_command "startinsert"
    end
  end, 100)
end

function M.setup()
  set_maps {
    {
      mode = "n",
      lhs = "<LEADER>lg",
      rhs = function()
        M.toggle_tool "lazygit"
      end,
      opts = { silent = true },
    },
    {
      mode = "n",
      lhs = "<LEADER>ld",
      rhs = function()
        M.toggle_tool "lazydocker"
      end,
      opts = { silent = true },
    },
    {
      mode = "n",
      lhs = "<LEADER>ls",
      rhs = function()
        M.toggle_tool "lazysql"
      end,
      opts = { silent = true },
    },
    {
      mode = "n",
      lhs = "<LEADER>br",
      rhs = function()
        M.toggle_tool "broot"
      end,
      opts = { silent = true },
    },
    {
      mode = "n",
      lhs = "<M-t>",
      rhs = function()
        local count = tonumber(vim.v.count) > 0 and tonumber(vim.v.count) or 1
        vim.cmd("ToggleTerm " .. count)
      end,
      opts = { noremap = true, silent = true },
    },
    {
      mode = "t",
      lhs = "<M-t>",
      rhs = function()
        local opened_tui_tool = get_opened_tui_tool()
        if opened_tui_tool then
          opened_tui_tool:toggle()
        else
          vim.cmd "ToggleTerm"
        end
      end,
      opts = { noremap = true, silent = true },
    },
  }
end

return M
