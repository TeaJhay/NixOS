---@module 'hl'

-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #

-- This is a file where you can put config and settings for plugins

-- to avoid clogging up the other config lua's



-- Hymission plugin: https://github.com/gfhdhytghd/hymission
if hl.plugin and hl.plugin.hymission then
  hl.config({
      plugin = {
          hymission = {
              -- Layout: common geometry and sizing
              outer_padding_top = 2,
              outer_padding_right = 32,
              outer_padding_bottom = 32,
              outer_padding_left = 32,
              row_spacing = 32,
              column_spacing = 132,
              min_window_length = 120,
              min_preview_short_edge = 32,
              small_window_boost = 1.35,
              max_preview_scale = 0.95,
              workspace_overview_max_preview_scale = 0.95,
              min_slot_scale = 0.10,
              one_workspace_per_row = 0,

              -- Layout: engine selection and per-engine settings
              layout_engine = "mission-control",
              layout_engine_forceall = "",
              layout_engine_all = "",
              layout_engine_onlycurrentworkspace = "",
              layout_scale_weight = 1.0,
              layout_space_weight = 0.10,
              natural_scale_flex = 0.22,

              -- Behavior: workspace scope and transitions
              multi_workspace_sort_recent_first = 1,
              only_active_workspace = 0,
              only_active_monitor = 0,
              show_special = 1,
              workspace_change_keeps_overview = 0,

              -- Behavior: hover and selection
              selected_expand_scale = 1.18,
              hover_expand_scale = 1.18,
              overview_focus_follows_mouse = 1,
              show_focus_indicator = 0,
              grouped_windows_policy = "collapsed",
              grouped_windows_collapsed_labels = 1,
              grouped_windows_collapsed_scroll = 1,

              -- Animation: hover relayout
              hover_relayout_animation = "",
              hover_relayout_duration = 140,
              hover_relayout_curve = "ease_out_cubic",

              -- Behavior: toggle switch and gestures
              toggle_switch_mode = 0,
              switch_toggle_auto_next = 1,
              switch_release_key = "Super_L",
              gesture_invert_vertical = 0,

              -- Niri mode
              niri_mode = 0,
              niri_scroll_pixels_per_delta = 1.0,
              niri_workspace_scale = 1.0,
              niri_scrolling_preview_gap = 0,

              -- Workspace strip and bar
              workspace_strip_anchor = "top",
              workspace_strip_empty_mode = "continuous",
              workspace_strip_thickness = 160,
              workspace_strip_gap = 50,
              hide_bar_when_strip = 1,
              hide_hyprbars_during_overview = 0,
              bar_single_mission_control = 1,
              hide_bar_animation = 1,
              hide_bar_animation_blur = 1,
              hide_bar_animation_move_multiplier = 0.8,
              hide_bar_animation_scale_divisor = 1.1,
              hide_bar_animation_alpha_end = 1,

              -- Label picking and window controls
              pick_labels_enabled = 1,
              pick_labels_show = 1,
              pick_labels_mode = "sequential",
              pick_labels_direct_activate = 0,
              window_decoration_enabled = 1,
              close_button_enabled = 1,
              close_button_size = 18,
              close_button_inset = 0,

              -- Appearance and color customization
              backdrop_blur = 0,
              backdrop_color = "rgba(00000000)",
              focus_hover_color = "rgba(f2f7ff8c)",
              focus_selected_color = "rgba(3dc7fff2)",
              focus_hover_thickness = 2,
              focus_selected_thickness = 4,
              workspace_strip_inactive_tint_color = "rgba(00000000)",

              -- Debug
              debug_logs = 0,
              debug_surface_logs = 0,
          },
      }
  })
end


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
    hg.layer("noctalia-attached-panel", { preset = "glass" })
    hg.layer("noctalia-notification", { preset = "glass" })
    hg.layer("noctalia-osd", { preset = "glass" })
    hg.layer("noctalia-window-switcher", { preset = "glass" })
    hg.layer("io.missioncenter.MissionCenter", { preset = "glass" })
    hg.layer("quickshell:bezel", { preset = "glass", mask_threshold = 0.3 })
    hg.layer("debug-panel", { exclude = true })

    -- Presets
    hg.preset("glass", {
        glass_opacity = 0.9,
        blur_strength = 2.0,
        blur_iterations = 3,
        chromatic_aberration = 0.7,
        fresnel_strength = 0.8,
        edge_thickness = 0.02,
        contrast = 1.4,
        lens_distortion = 0.4,
        saturation = 1.0,
        vibrancy = 0.8,
        vibrancy_darkness = 1,
        adaptive_boost = 0.5,
        brightness = 1.3

    })

    hg.preset("contrasted", {
        inherits = "high_contrast",
        contrast = 1.2,
        adaptive_dim = 1.5,
        dark = { tint_color = 0x02142aa9 },
    })
end


