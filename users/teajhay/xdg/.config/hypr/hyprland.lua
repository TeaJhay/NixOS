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
Monitors = require("lua/Monitors") -- Monitors
Startup_Apps = require("lua/StartupApps") -- Startup apps
--ENVariable = require("lua/ENVariables") -- Environment variables # NOTE: Not needed anymore. Declare in nix.
WindowRules = require("lua/WindowRules") -- Window Rules
LayerRules = require("lua/LayerRules") -- Layer Rules
WorkspaceRules = require("lua/WorkspaceRules") --  Workspace Rules
SystemSettings = require("lua/SystemSettings") -- Default config for hypr
Decorations = require("lua/Decorations") -- Decorations config file
Animations = require("lua/Animations") -- Animation config file
