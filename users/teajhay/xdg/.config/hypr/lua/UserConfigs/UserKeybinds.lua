-- User keybind overrides (auto-generated).
-- luacheck: globals hl vim, max_line_length 200
-- Add keybinds with bind("MODS", "KEY", fn, opts).
-- Example:
-- bind("SUPER", "Z", exec_cmd("ghostty"), { description = "Launch ghostty" })
-- Helper functions live in ~/.config/hypr/lua/user_keybinds_helper.lua so they can be updated separately.

hl.bind("SUPER + SHIFT + Return", hl.dsp.workspace.toggle_special("Dropdown"))

hl.bind("SUPER + V", hl.dsp.workspace.toggle_special("Vesktop"))

--hl.bind("SUPER + SHIFT + Return", hl.dsp.workspace.toggle_special("Dropdown"))
--
--hl.bind("SUPER + SHIFT + Return", hl.dsp.workspace.toggle_special("Dropdown"))
--
--hl.bind("SUPER + SHIFT + Return", hl.dsp.workspace.toggle_special("Dropdown"))
