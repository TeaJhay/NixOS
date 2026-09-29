{pkgs, ...}: {
  hjem.users."teajhay".files.".config/hypr/lua/Keybinds.lua".source =
    pkgs.writeText "hyprland.lua"
    /*
    lua
    */
    ''
      -- Based on and edited from the lovely dots provided by LinuxBeginnings!
      -- /* ---- 💫 https://github.com/LinuxBeginnings 💫 ---- */  #

      -- luacheck: globals hl vim, max_line_length 200
      -- Add keybinds with bind("MODS", "KEY", fn, opts).
      -- Example:
      -- bind("SUPER", "Z", exec_cmd("ghostty"), { description = "Launch ghostty" })

      local mainMod = "SUPER"

      local ScriptsDir = os.getenv("HOME") .. "/.config/hypr/scripts"

      local UserScripts = os.getenv("HOME") .. "/.config/hypr/scripts"

      --### STANDARD ####

      -- Common shortcuts

      hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))

      hl.bind(mainMod .. " + B", hl.dsp.exec_cmd('xdg-open "https://"'))

      -- Toggles quickshell or ags overview (tries QS first, falls back to AGS)

      hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(ScriptsDir .. "/OverviewToggle.sh"))

      -- Default apps

      hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("$TERMINAL"))

      hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("$TERMINAL $FILES"))

      hl.bind(mainMod .. " + CTRL + E ", hl.dsp.exec_cmd("$TERMINAL $EDITOR"))

      -- FEATURES / EXTRAS

      -- TODO: Would like to make this read this file and generate a nice keybinds list from it.
      --hl.bind(mainMod .. " + H", hl.dsp.exec_cmd(ScriptsDir .. "/KeyHints.sh"))

      -- TODO: Not a bad idea, but should really only use hyprctl dispatch '(...)' in a script (or a lua function!)
      --hl.bind(mainMod .. " + SHIFT + G", hl.dsp.exec_cmd(ScriptsDir .. "/GameMode.sh"))

      hl.bind(mainMod .. " + ALT + V", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"))

      hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen())

      hl.bind(mainMod .. " + SPACE", hl.dsp.window.float())

      -- TODO: Very cool, make this lua.

      hl.bind(mainMod .. " + ALT + SPACE", hl.dsp.exec_cmd(ScriptsDir .. "/Float-all-Windows.sh"))

      -- Desktop zooming or magnifier

      hl.bind(
        mainMod .. " + ALT + mouse_up",
        hl.dsp.exec_cmd(
          [[hyprctl eval "hl.config({ cursor = { zoom_factor = $(hyprctl getoption cursor:zoom_factor | awk 'NR==1 {f=$2; if (f<1) f=1; print f*1.5}') } })"]]
        )
      )

      hl.bind(
        mainMod .. " + ALT + mouse_down",
        hl.dsp.exec_cmd(
          [[hyprctl eval "hl.config({ cursor = { zoom_factor = $(hyprctl getoption cursor:zoom_factor | awk 'NR==1 {f=$2; if (f<1) f=1; r=f/1.5; if (r<1) r=1; print r}') } })"]]
        )
      )

      -- Waybar / Bar related

      -- Night light toggle

      hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("noctalia msg nightlight-toggle"))

      -- Wallpapers

      hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("noctalia msg panel-toggle wallpaper"))

      hl.bind(mainMod .. " + ALT + W", hl.dsp.exec_cmd("noctalia msg wallpaper-random"))

      -- Set window to opaque and nodim

      hl.bind(mainMod .. " + CTRL + O", function()
        hl.dispatch(hl.dsp.window.set_prop({
          prop = "opaque",
          value = "toggle",
        }))

        hl.dispatch(hl.dsp.window.set_prop({
          prop = "no_dim",
          value = "toggle",
        }))
      end)

      -- Open calc

      hl.bind(mainMod .. " + ALT + C", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher /calc"))

      -- Move current workspaces to monitors (left, right, up, down)

      hl.bind(
        mainMod .. " + CTRL + F9",
        hl.dsp.workspace.move({ monitor = "l" }),
        { description = "Move current workspaces to left monitor" }
      )

      hl.bind(
        mainMod .. " + CTRL + F10",
        hl.dsp.workspace.move({ monitor = "r" }),
        { description = "Move current workspaces to right monitor" }
      )

      hl.bind(
        mainMod .. " + CTRL + F11",
        hl.dsp.workspace.move({ monitor = "u" }),
        { description = "Move current workspaces to upper monitor" }
      )

      hl.bind(
        mainMod .. " + CTRL + F12",
        hl.dsp.workspace.move({ monitor = "d" }),
        { description = "Move current workspaces to lower monitor" }
      )

      -- System

      hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("noctalia msg panel-toggle session"))

      hl.bind(mainMod .. " + Q", hl.dsp.window.close())

      hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.kill())
      hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("noctalia msg session lock"))

      hl.bind(mainMod .. " + CTRL + ALT + P", hl.dsp.exec_cmd("noctalia msg session lock-and-suspend"))

      hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center"))

      -- Vim keys cycle windows globally

      hl.bind(mainMod .. " + j", hl.dsp.window.cycle_next())

      hl.bind(mainMod .. " + k", hl.dsp.window.cycle_next({ next = false }))

      -- Dwindle Layout

      hl.bind(mainMod .. " + SHIFT + I", hl.dsp.layout("togglesplit"))

      hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

      -- Works on either layout (Master or Dwindle)

      hl.bind(mainMod .. " + M", hl.dsp.layout("splitratio 0.3 exact"))

      -- layout aware keybinds

      -- Cycle layout

      hl.bind(mainMod .. "+ ALT + BackSpace", function()
        local layouts = { "scrolling", "dwindle", "master", "monocle" }
        local workspace = hl.get_active_workspace()
        if hl.get_active_special_workspace() then
          workspace = hl.get_active_special_workspace()
        end

        local next_layout = "dwindle"

        if not workspace then
          return
        end

        for i = 1, #layouts do
          if layouts[i] == workspace.tiled_layout then
            local next_layout_idx = (i % #layouts) + 1
            next_layout = layouts[next_layout_idx]
            break
          end
        end

        if workspace.special then
          hl.workspace_rule({ workspace = tostring(workspace.name), layout = next_layout })
        else
          hl.workspace_rule({ workspace = "name:" .. tostring(workspace.name), layout = next_layout })
        end
      end)

      -- Scrolling Layout

      hl.bind(mainMod .. " + SHIFT + period", hl.dsp.layout("move +col"))

      hl.bind(mainMod .. " + SHIFT + comma", hl.dsp.layout("move -col"))

      hl.bind(mainMod .. " + ALT + comma", hl.dsp.layout("swapcol l"))

      hl.bind(mainMod .. " + ALT + period", hl.dsp.layout("swapcol r"))

      -- Set layout to Horizontal (Standard "Tape" style)

      hl.bind(mainMod .. " + ALT + H", hl.dsp.exec_cmd("hyprctl keyword scrolling:direction right"))

      -- Set layout to Vertical (Stacked "Column" style)

      hl.bind(mainMod .. " + ALT + V", hl.dsp.exec_cmd("hyprctl keyword scrolling:direction down"))

      -- Create a toggle bind (e.g., Mod + Shift + S)

      -- Cycle windows; if floating bring to top

      hl.bind("ALT + Tab", hl.dsp.window.cycle_next())

      hl.bind("ALT + Tab", hl.dsp.window.bring_to_top(), { description = "Bring active to top" })

      -- Leave special windows; only if active

      hl.bind(mainMod .. " + TAB", function()
        local special = hl.get_active_special_workspace()
        if special then
          local name = special.name:gsub("^special:", "")
          hl.dispatch(hl.dsp.workspace.toggle_special(name))
        else
          hl.dispatch(hl.dsp.focus({ workspace = "m+1" }))
        end
      end)

      -- Special Keys / Hot Keys

      hl.bind("xf86audioraisevolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
      hl.bind("xf86audiolowervolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
      hl.bind(
        "ALT + xf86audioraisevolume",
        hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+"),
        { repeating = true }
      )

      hl.bind("ALT + XF86audiolowervolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"), { locked = true })

      hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })

      hl.bind("XF86audiomute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

      hl.bind("xf86Sleep", hl.dsp.exec_cmd("systemctl suspend"), { locked = true })

      hl.bind("xf86Rfkill", hl.dsp.exec_cmd(ScriptsDir .. "/AirplaneMode.sh"), { locked = true })

      -- media controls using keyboards
      hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })

      hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

      -- Skip player on long press and only skip 5s on normal press
      hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { long_press = true })

      hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { long_press = true })

      hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl position +5"))

      hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl position -5"))

      -- NOTE: Trying playerctl binds, but will keep these in case.

      --hl.bind("XF86AudioPlayPause", hl.dsp.exec_cmd(ScriptsDir .. "/MediaCtrl.sh --pause"), { locked = true })

      --hl.bind("XF86AudioPause", hl.dsp.exec_cmd(ScriptsDir .. "/MediaCtrl.sh --pause"), { locked = true })

      --hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(ScriptsDir .. "/MediaCtrl.sh --pause"), { locked = true })

      --hl.bind("XF86AudioNext", hl.dsp.exec_cmd(ScriptsDir .. "/MediaCtrl.sh --nxt"), { locked = true })

      --hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(ScriptsDir .. "/MediaCtrl.sh --prv"), { locked = true })

      --hl.bind("xf86audiostop", hl.dsp.exec_cmd(ScriptsDir .. "/MediaCtrl.sh --stop"), { locked = true })

      -- Screenshot keybindings NOTE: Looks at importing to swappy?

      hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen"))

      hl.bind(mainMod .. " + SHIFT + Print", hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen all"))

      hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("noctalia msg screenshot-region"))

      -- WARN: Change this to a command not a script.

      -- hl.bind("ALT + Print", hl.dsp.exec_cmd(ScriptsDir .. "/ScreenShot.sh --active"))

      --hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(ScriptsDir .. "/ScreenShot.sh --swappy"))

      -- Resize windows

      hl.bind(mainMod .. " + SHIFT + R", hl.dsp.submap("resize"))

      -- Start a submap called "resize".
      hl.define_submap("resize", function()
        -- Set repeating binds for resizing the active window.
        hl.bind("right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
        hl.bind("left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
        hl.bind("up", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
        hl.bind("down", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })

        -- Use `reset` to go back to the global submap
        hl.bind("escape", hl.dsp.submap("reset"))
      end)

      -- Move windows

      hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "l" }))

      hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))

      hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u" }))

      hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }))

      -- Swap windows

      hl.bind(mainMod .. " + ALT + left", hl.dsp.window.swap({ direction = "left" }))

      hl.bind(mainMod .. " + ALT + right", hl.dsp.window.swap({ direction = "right" }))

      hl.bind(mainMod .. " + ALT + up", hl.dsp.window.swap({ direction = "up" }))

      hl.bind(mainMod .. " + ALT + down", hl.dsp.window.swap({ direction = "down" }))

      -- group

      hl.bind(mainMod .. " + G", hl.dsp.group.toggle())

      -- Navigate within a group

      -- hl.bind(mainMod .. " + Tab", hl.dsp.group.next({ forward = false }))

      hl.bind(mainMod .. " + CTRL + tab", hl.dsp.group.next({ forward = false }))

      hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.group.next({ forward = false }))

      -- Move window into/out of group

      hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.move({ into_group = "left" }))

      -- Move active window left into a group A

      hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.move({ into_group = "right" }))

      -- Move active window right into a group

      hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.move({ out_of_group = true }))

      -- Move active window out of group

      -- Try to dynamically move in grouped window and when ungrouped

      -- Move focus with mainMod + arrow keys

      hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))

      hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))

      hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))

      hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

      -- Workspaces related

      hl.bind(mainMod .. " + SHIFT + tab", hl.dsp.focus({ workspace = "m-1" }))

      -- Special workspace(s)

      hl.bind(mainMod .. " + T", hl.dsp.workspace.toggle_special("mailbox"))

      hl.bind(mainMod .. " + SHIFT + U", hl.dsp.window.move({ workspace = "special" }))

      hl.bind(mainMod .. " + U", hl.dsp.workspace.toggle_special(nil))

      hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.workspace.toggle_special("Dropdown"))

      hl.bind(mainMod .. " + V", hl.dsp.workspace.toggle_special("Vesktop"))

      -- The following mappings use the key codes to better support various keyboard layouts
      -- 1 is code:10, 2 is code 11, 0 is code 19 etc
      -- Switch workspaces with mainMod + [0-9]

      for n = 1, 10 do
        hl.bind(mainMod .. " + code:" .. (n + 9), hl.dsp.focus({ workspace = n }))
      end

      -- Move active window and follow to workspace mainMod + SHIFT [0-9]

      for n = 1, 10 do
        hl.bind(mainMod .. " + SHIFT + code:" .. (n + 9), hl.dsp.window.move({ workspace = n }))
      end

      -- Brackets [

      hl.bind(mainMod .. " + SHIFT + bracketleft", hl.dsp.window.move({ workspace = "-1" }))
      -- Silent
      hl.bind(mainMod .. " + CTRL + bracketleft", hl.dsp.window.move({ workspace = "-1", follow = false }))
      -- Brackets ]

      hl.bind(mainMod .. " + SHIFT + bracketright", hl.dsp.window.move({ workspace = "+1" }))
      -- Silent
      hl.bind(mainMod .. " + CTRL + bracketright", hl.dsp.window.move({ workspace = "+1", follow = false }))

      -- Move active window to a workspace silently mainMod + CTRL [0-9]

      for n = 1, 10 do
        hl.bind(mainMod .. " + CTRL + code:" .. (n + 9), hl.dsp.window.move({ workspace = n, follow = false }))
      end

      -- Scroll through existing workspaces with mainMod + scroll

      hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "+1" }))

      hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "-1" }))

      hl.bind(mainMod .. " + period", hl.dsp.focus({ workspace = "e+1" }))

      hl.bind(mainMod .. " + comma", hl.dsp.focus({ workspace = "e-1" }))

      -- Move/resize windows with mainMod + LMB/RMB and dragging

      hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })

      -- NOTE: mouse:272 = left click

      hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

      -- NOTE: mouse:272 = right click

      -- Autostart
      hl.on("hyprland.start", function()
        hl.exec_cmd(ScriptsDir .. "/ChangeLayout.sh init")
      end)
    
'';
}
