local _C = require "consts"
local _wt = require "wezterm"
local _u = require "utils"

local config = {}
if _wt.config_builder then
  config = _wt.config_builder()
end

config.font_shaper = "Harfbuzz"
_wt.font("0xProto", { weight = "Regular", stretch = "Normal", style = "Italic" })
config.harfbuzz_features = {
  "ss02",
  "ss03",
  "ss04",
  "ss05",
  "ss06",
  "zero",
  "onum",
  "calt=0",
  "clig=0",
  "liga=0",
}

config.line_height = 0.9
config.colors = require "colors"
config.window_decorations = "RESIZE"
config.default_prog = { "wsl", "~" }
config.window_background_opacity = 0.85
config.window_close_confirmation = "NeverPrompt"
config.audible_bell = "Disabled"
config.tab_bar_at_bottom = true
config.skip_close_confirmation_for_processes_named = {
  "bash",
  "sh",
  "zsh",
  "fish",
  "tmux",
  "nu",
  "cmd.exe",
  "pwsh.exe",
  "powershell.exe",
  "wsl.exe",
  "wslhost.exe",
  "conhost.exe",
}

-- open window in maximum size
local mux = _wt.mux
_wt.on("gui-startup", function()
  local _, _, window = mux.spawn_window {}
  window:gui_window():maximize()
end)

-- register F13 as toggleable layer key
_u.register_toggleable_layer_key(_C.F13)

-- import key settigs after registering layer keys
config.keys = require "keys"

-- handling tab title
_wt.on("format-tab-title", function(tab)
  local title = _u.get_tab_title(tab)

  -- if nvim isn't running, show default title
  if not string.find(title, "NVIM") then
    return { { Text = title } }
  end

  -- else show cwd
  -- by default, remove 3 directories on the left
  local num = 3
  if string.find(title, "dotfiles") then
    -- if dotfiles directory is opened, remove only 1 directory
    num = 1
  end

  local short_title = _u.remove_left_dirs(title:match "%((.+)%)", num)

  if short_title == "" then
    title = title
  else
    title = short_title
  end

  return { { Text = title } }
end)

return config
