local _C = require "consts"

local M = {}

function M.build(active_tab_bg_color)
  return {
    tab_bar = {
      active_tab = {
        bg_color = active_tab_bg_color or _C.COLOR_TAB_BAR_BG_DEFAULT,
        fg_color = _C.COLOR_TAB_BAR_FG_DEFAULT,
      },
    },
    cursor_bg = "#FFFF00",
    cursor_fg = "#000000",
    foreground = "#DDDDDD",
  }
end

return M
