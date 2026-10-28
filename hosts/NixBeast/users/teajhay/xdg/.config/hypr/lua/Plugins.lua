-- /* ---- 💫 https://github.com/LinuxBeginnings 💫 ---- */  #

-- This is a file where you can put config and settings for plugins
-- to avoid clogging up the other config lua's
--luacheck: globals hl
-- Hyprglass plugin: https://github.com/hyprnux/hyprglass
if hl.plugin.hyprglass then
  local hg = hl.plugin.hyprglass

  hg.config({
    enabled = true,
    default_theme = "light",
    default_preset = "glass",
    tint_color = 0x1F000000,
    brightness = 0.8,
    --dark = { brightness = 0.82 },
    -- light = { adaptive_boost = 0.5 },

    layers = { enabled = true },
  })

  -- Layer surfaces: each call whitelists the namespace and configures it
  --hg.layer("waybar", { preset = "subtle", mask_threshold = 0.05 })
  hg.layer("noctalia-bar-default", { preset = "glass" })
  hg.layer("noctalia-dock", { preset = "glass" })
  hg.layer("noctalia-panel", { preset = "glass" })
  hg.layer("noctalia-bar-top", { preset = "glass" })
  hg.layer("noctalia-attached-panel", { preset = "glass" })
  hg.layer("noctalia-notification", { preset = "glass" })
  hg.layer("noctalia-osd", { preset = "glass" })
  hg.layer("noctalia-window-switcher", { preset = "glass" })
  hg.layer("io.missioncenter.MissionCenter", { preset = "glass" })
  hg.layer("quickshell:bezel", { preset = "glass", mask_threshold = 0.3 })
  hg.layer("debug-panel", { exclude = true })

  -- Presets
  hg.preset("glass", {
    glass_opacity = 0.8,
    blur_strength = 1.5,
    blur_iterations = 3,
    chromatic_aberration = 0.3,
    fresnel_strength = 0.8,
    edge_thickness = 0.01,
    contrast = 1.0,
    lens_distortion = 0.4,
    saturation = 1.0,
    vibrancy = 0.8,
    vibrancy_darkness = 1,
    adaptive_boost = 0.5,
    brightness = 1.3,
  })

  hg.preset("contrasted", {
    inherits = "high_contrast",
    contrast = 1.2,
    adaptive_dim = 1.5,
    dark = { tint_color = 0x02142aa9 },
  })
end
