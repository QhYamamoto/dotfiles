local _C = require "consts"
local _wt = require "wezterm"
local _u = require "utils"

local act = _wt.action

local toggleable_layer_key_action = function(window, pane, toggleable_layer_key, key, action)
  if _u.get_layer_key_flag(toggleable_layer_key) then
    window:perform_action(action, pane)
  else
    window:perform_action(act { SendKey = { key = key } }, pane)
  end
end

return {
  -- tabs
  { key = "t", mods = "SHIFT|CTRL", action = act.SpawnTab "CurrentPaneDomain" },
  -- tmux pane navigation
  { key = "h", mods = "ALT", action = act.SendKey { key = "h", mods = "CTRL" } },
  { key = "j", mods = "ALT", action = act.SendKey { key = "j", mods = "CTRL" } },
  { key = "k", mods = "ALT", action = act.SendKey { key = "k", mods = "CTRL" } },
  { key = "l", mods = "ALT", action = act.SendKey { key = "l", mods = "CTRL" } },
  { key = "d", mods = "CTRL|SHIFT", action = act.CloseCurrentPane { confirm = true } },
  -- cursor movements
  { key = "LeftArrow", mods = "SHIFT|CTRL", action = act.SendKey { key = "b", mods = "META" } },
  { key = "RightArrow", mods = "CTRL", action = act.SendKey { key = "f", mods = "META" } },
  { key = "LeftArrow", mods = "CTRL", action = act.SendKey { key = "b", mods = "META" } },
  { key = "i", mods = "SHIFT|CTRL", action = act.SendKey { key = "e", mods = "CTRL" } },
  -- copy & paste
  { key = "v", mods = "SHIFT|CTRL", action = act.ActivateCopyMode },
  { key = "v", mods = "CTRL", action = act.PasteFrom "Clipboard" },
  -- F13 layer key mappings
  {
    key = _C.F13,
    mods = "NONE",
    action = act { EmitEvent = _u.get_layer_key_toggle_event(_C.F13) },
  },
  {
    key = "LeftArrow",
    mods = "NONE",
    action = _wt.action_callback(function(window, pane)
      toggleable_layer_key_action(window, pane, _C.F13, "LeftArrow", act { MoveTabRelative = -1 })
    end),
  },
  {
    key = "RightArrow",
    mods = "NONE",
    action = _wt.action_callback(function(window, pane)
      toggleable_layer_key_action(window, pane, _C.F13, "RightArrow", act { MoveTabRelative = 1 })
    end),
  },
  {
    key = "UpArrow",
    mods = "NONE",
    action = _wt.action_callback(function(window, pane)
      toggleable_layer_key_action(window, pane, _C.F13, "UpArrow", act { ScrollByLine = -1 })
    end),
  },
  {
    key = "DownArrow",
    mods = "NONE",
    action = _wt.action_callback(function(window, pane)
      toggleable_layer_key_action(window, pane, _C.F13, "DownArrow", act { ScrollByLine = 1 })
    end),
  },
  {
    key = "u",
    mods = "NONE",
    action = _wt.action_callback(function(window, pane)
      toggleable_layer_key_action(window, pane, _C.F13, "u", act { ScrollByPage = -0.5 })
    end),
  },
  {
    key = "d",
    mods = "NONE",
    action = _wt.action_callback(function(window, pane)
      toggleable_layer_key_action(window, pane, _C.F13, "d", act { ScrollByPage = 0.5 })
    end),
  },
}
