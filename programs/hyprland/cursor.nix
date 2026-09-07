{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkIf gvariant;
  cfg = config.programs.hyprland;
in
{
  config = mkIf cfg.enable {
    environment.sessionVariables = {
      HYPRCURSOR_THEME = "Bibata-Modern";
      HYPRCURSOR_SIZE = 24;
      XCURSOR_THEME = "Bibata-Modern-Classic";
      XCURSOR_SIZE = 24;
      # as a list makes this append to instead of overwrite.
      XCURSOR_PATH = [ "${pkgs.bibata-cursors}/share/icons" ];
    };
    hjem.users.teajhay = {
      xdg = {
        # idk why some files read from here, but if you're ever having
        # problems with cursor themes not working on some apps, try this.
        data.files."icons/default/index.theme" = {
          generator = lib.generators.toINI { };
          value = {
            "Icon Theme".Inherits = "Bibata-Modern-Classic";
          };
        };
      };
      packages = [
        (inputs.niqspkgs.packages.${pkgs.stdenv.hostPlatform.system}.bibata-hyprcursor.override {
          variant = "modern";
        })
        pkgs.bibata-cursors
      ];
    };
    programs.dconf.profiles.user.databases = [
      {
        lockAll = true;
        settings = {
          "org/gnome/desktop/interface" = {
            cursor-theme = "Bibata-Modern-Classic";
            cursor-size = gvariant.mkInt32 24;
          };
        };
      }
    ];
  };
}

