-- ==================================================
--  KoolDots (2026)
--  Project URL: https://github.com/LinuxBeginnings
--  License: GNU GPLv3
--  SPDX-License-Identifier: GPL-3.0-or-later
-- ==================================================

-- Converted from config/hypr/UserConfigs/UserDecorations.conf.
-- NOTE: wallust-hyprland.conf is hyprlang-sourced in the original config.
-- Lua parity for importing that file is still evolving; using static color fallbacks here.

hl.config({
    general = {
        border_size = 4,
        gaps_in = 7,
        gaps_out = 15,
        col = {
           active_border = "rgba(8db4ffff)",
           inactive_border = "rgba(5f6578ff)",
        },
    },
})

hl.config({
    decoration = {
        rounding = 1,
        active_opacity = 1.0,
        inactive_opacity = 1,
        fullscreen_opacity = 1.0,
        dim_inactive = true,
        dim_strength = 0.1,
        dim_special = 0.8,
        shadow = {
            enabled = true,
            range = 10,
            render_power = 2,
            color = "rgba(390d77d9)",
            color_inactive = "rgba(5f657800)",
        },
        blur = {
            enabled = false,
            size = 6,
            passes = 3,
            new_optimizations = true,
            xray = true,
            ignore_opacity = true,
            special = true,
            popups = true,
        },
    },
})

hl.config({
    group = {
        col = {
            border_active = "rgba(ffffffff)",
        },
        groupbar = {
            col = {
                active = "rgba(0f111aff)",
            },
        },
    },
})



-- Animated RGB border
local rainbow_colors = {
    "rgba(ff00007f)", -- red
    "rgba(ff80007f)", -- orange
    "rgba(ffff007f)", -- yellow
    "rgba(00ff007f)", -- green
    "rgba(00ffff7f)", -- cyan
    "rgba(0080ff7f)", -- blue
    "rgba(0000ff7f)", -- blue
    "rgba(8000ff7f)", -- purple
    "rgba(ff00ff7f)", -- magenta
}

local angle = 0

local rainbow_timer = hl.timer(function()
    angle = (angle + 2) % 360

    hl.config({
        general = {
            col = {
                active_border = {
                    colors = rainbow_colors,
                    angle = angle,
                },
            },
        },
    })
end, {
    timeout = 80,
    type = "repeat",
})
