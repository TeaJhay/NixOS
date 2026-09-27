{pkgs, ...}: {
  hjem.users."teajhay".files.".config/hypr/hyprland.lua".source =
    pkgs.writetext "hyprland.lua"
    /*
    lua
    */
    ''
      -- Initial boot script enable to apply initial wallpapers, theming, new settings etc.

      --hl.on("hyprland.start", function()
      --  hl.exec_cmd(os.getenv("HOME") .. "/.config/hypr/initial-boot.sh")
      --end)

      -- suggest not to change this or delete this including deleting referrence file in ~/.config/hypr/.initial_startup_done

      -- as long as the referrence file is present, this initial-boot.sh will not execute

      -- Sourcing external config files
      -- Pre-configured keybinds, plguins and monitors
      Keybinds = require("lua/Keybinds") -- Keybinds
      Plugins = require("lua/Plugins") -- Plugins + Configs
      Monitors = require("lua/monitors") -- Monitors
      Startup_Apps = require("lua/Startup_Apps") -- Startup apps
      ENVariable = require("lua/ENVariables") -- Environment variables
      WindowRules = require("lua/Configs/WindowRules") -- Window Rules
      LayerRules = require("lua/Configs/LayerRules") -- Layer Rules
      WorkspaceRules = require("lua/WorkspaceRules") --  Workspace Rules
      SystemSettings = require("lua/Configs/SystemSettings") -- Default config for hypr
      Decorations = require("lua/UserConfigs/Decorations") -- Decorations config file
      Animations = require("lua/UserConfigs/Animations") -- Animation config file
    '';
}
