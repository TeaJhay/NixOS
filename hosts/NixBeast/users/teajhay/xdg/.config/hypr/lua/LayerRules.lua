-- /* ---- 💫 https://github.com/LinuxBeginnings 💫 ---- */  #

-- For layerrules

-- See https://wiki.hyprland.org/Configuring/Window-Rules/ for more

-- This file is used to add or overwrite layer rules

-- This file will not be modified during dotfiles updates

-- Example:

-- layerrule = blur on, ignore_alpha 0, match:namespace rofi

local layer_rules = {
  { "nwg-drawer", 0.25 },
  { "nwg-dock*", 0.25 },
  { "rofi", 0 },
  { "notifications", 0 },
  { "quickshell:overview", 0.5 },
  { "wallpaper", 0 },
  { "swaync-notification-window", 0 },
  { "com.aurora.keybinds_help", 0 },
  { "logout_dialog", 0 },
}

for _, rule in ipairs(layer_rules) do
  local opts = {
    match = { namespace = rule[1] },
    blur = true,
    ignore_alpha = rule[2],
  }
  for k, v in pairs(rule[3] or {}) do
    opts[k] = v
  end
  hl.layer_rule(opts)
end

hl.layer_rule({
  match = { namespace = "nwg-drawer" },
  blur = true,
  ignore_alpha = 0.25,
})

hl.layer_rule({
  match = {
    namespace = "blur on",
  },
})

-- LAYER RULES

hl.layer_rule({
  match = {
    namespace = "blur on",
  },
})

hl.layer_rule({
  match = {
    namespace = "blur on",
  },
})

hl.layer_rule({
  match = {
    namespace = "blur on",
  },
})

hl.layer_rule({
  match = {
    namespace = "blur on",
  },
})

-- swaync + helper overlays

-- Disable causes huge blue on notifications

--layerrule = match:namespace swaync-control-center, blur on, ignore_alpha 0

hl.layer_rule({
  match = {
    namespace = "blur on",
  },
})

hl.layer_rule({
  match = {
    namespace = "blur on",
  },
})

hl.layer_rule({
  match = {
    namespace = "blur on",
  },
})

--  Optional Layer rules

--  To Resolve blurred corners in rofi  Add to User config

--  SUPER SHIFT + E   Edit User Layer Rules

--layerrule = blur on, ignore_alpha 0, match:namespace rofi

--layerrule = blur on, match:namespace waybar
