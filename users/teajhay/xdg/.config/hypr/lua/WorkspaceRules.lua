-- /* ---- 💫 https://github.com/LinuxBeginnings 💫 ---- */  #

-- luacheck: globals hl vim, max_line_length 200

-- For workspace rules

-- See https://wiki.hyprland.org/Configuring/workspace-Rules/ for more

-- This file is used to add or overwrite workspace rules

-- This file will not be modified during dotfiles updates

-- to trigger an app to be started when a workspace is created, add the workspace ID and exec_cmd command to the table.
hl.on("workspace.created", function(ws)
  local workspace_programs = {
    ["special:Vesktop"] = { cmd = "vesktop", opts = nil },
    ["special:mailbox"] = { cmd = "thunderbird", opts = nil },
    ["special:Dropdown"] = { cmd = "kitty", opts = nil },
    ["special:btop"] = { cmd = "kitty btop", opts = { tag = "specialbtop" } },
  }
  local program = workspace_programs[ws.name]
  if program and ws.is_empty then
    hl.exec_cmd(program.cmd, program.opts)
  end
end)

hl.workspace_rule({ workspace = "special:Dropdown", gaps_out = 50, gaps_in = 50 })

hl.workspace_rule({
  workspace = "special:btop",
  gaps_out = 50,
  gaps_in = 50,
})

local TARGET = "special:btop"
local prev_special = {} -- monitor name -> name of its active special workspace (or nil)

hl.on("workspace.special_active", function(_, mon)
  local monName = mon.name
  local was = prev_special[monName]
  local nowWs = mon.active_special_workspace
  local now = nowWs and nowWs.name or nil
  -- We just left TARGET on this monitor
  if was == TARGET and now ~= TARGET then
    local btop = hl.get_workspace(TARGET)
    if btop then
      for _, w in ipairs(btop:get_windows()) do
        hl.dispatch(hl.dsp.window.close({ window = w }))
      end
    end
  end

  prev_special[monName] = now
end)
