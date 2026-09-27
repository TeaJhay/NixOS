{pkgs, ...}: {
  hjem.users."teajhay".files.".config/hypr/lua/StartupApps.lua".source =
    pkgs.writetext "hyprland.lua"
    /*
    lua
    */
    ''
      -- /* ---- 💫 https://github.com/LinuxBeginnings 💫 ---- */  #

      -- Commands and Apps to be executed at launch

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
    '';
}
