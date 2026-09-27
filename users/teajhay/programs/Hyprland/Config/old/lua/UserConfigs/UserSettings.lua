-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
-- User Settings
-- This is where you put your own settings as this will not be touched during update 
-- if the upgrade.sh is used.
--
-- refer to Hyprland wiki for more info https://wiki.hyprland.org/Configuring/Variables/
-- NOTE: some settings are in ~/.config/hypr/UserConfigs/UserDecorAnimations.conf
--
-- Look on ~/.config/hypr/configs/SystemSettings.conf to know how to modify this


hl.workspace_rule({ workspace = "5", layout_opts = { direction = "up" } })


hl.config({ 
  scrolling = {
    explicit_column_widths = "0.333, 0.333,0.333"


  },
 -- general = {
 --   layout = "scrolling"
 -- }

})
