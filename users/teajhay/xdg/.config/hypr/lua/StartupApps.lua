-- /* ---- 💫 https://github.com/LinuxBeginnings 💫 ---- */  #

-- Commands and Apps to be executed at launch

local scriptsDir = os.getenv("HOME") .. "/.config/hypr/scripts"

local UserScripts = os.getenv("HOME") .. "/.config/hypr/UserScripts"

local LuaScripts = os.getenv("HOME") .. "/.config/hypr/lua/LuaScripts"

-- Autostart
hl.on("hyprland.start", function()
  hl.exec_cmd("sleep 7 && vesktop --ozone-platform-hint=auto --start-minimized")

  hl.exec_cmd("udiskie")
  --hl.exec_cmd("steam -silent")
  hl.exec_cmd("xrandr --output HDMI-A-1 --primary")
  --hl.exec_cmd("/usr/lib/pam_kwallet_init")
  hl.exec_cmd("systemctl --user start hyprland-session.target")
end)

hl.on("hyprland.start", function()
  hl.exec_cmd("noctalia")
  hl.exec_cmd("hypr-cursor-warp")
  hl.exec_cmd(UserScripts .. "/RainbowBorders.sh")
  hl.exec_cmd(scriptsDir .. "/KeybindsLayoutInit.sh")
  hl.exec_cmd("qs -c overview")
end)
