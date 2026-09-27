{pkgs, ...}: {
  hjem.users."teajhay".files.".config/hypr/lua/WindowRules.lua".source =
    pkgs.writetext "hyprland.lua"
    /*
    lua
    */
    ''
      -- /* ---- 💫 https://github.com/LinuxBeginnings 💫 ---- */  #

      -- luacheck: globals hl vim, max_line_length 200

      -- For window rules and layerrules

      -- See https://wiki.hyprland.org/Configuring/Window-Rules/ for more

      -- This file is used to add or overwrite window rules

      -- This file will not be modified during dotfiles updates

      hl.window_rule({
        name = "Vesktop-to-special",
        match = { initial_class = "^([Dd]iscord|[Ww]ebCord|[Vv]esktop)$" },
        workspace = "special:Vesktop silent",
        no_initial_focus = true,
      })
    '';
}
