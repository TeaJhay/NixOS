{pkgs, ...}: {
  hjem.users."teajhay".files.".config/hypr/lua/LayerRules.lua".source =
    pkgs.writetext "hyprland.lua"
    /*
    lua
    */
    ''
      -- /* ---- 💫 https://github.com/LinuxBeginnings 💫 ---- */  #

      -- For layerrules

      -- See https://wiki.hyprland.org/Configuring/Window-Rules/ for more

      -- This file is used to add or overwrite layer rules

      -- This file will not be modified during dotfiles updates

      -- Example:

      -- layerrule = blur on, ignore_alpha 0, match:namespace rofi
    '';
}
