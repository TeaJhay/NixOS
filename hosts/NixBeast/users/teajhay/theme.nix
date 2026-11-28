{
  pkgs,
  lib,
  inputs,
  ...
}: {
  hjem.users.teajhay = {
    packages = with pkgs; [
      adw-gtk3
      papirus-icon-theme
      (symlinkJoin {
        name = "qt-theming";
        paths = [
          qt6Packages.qt6ct
          qt6Packages.qtstyleplugin-kvantum
        ];
        postBuild = ''
          unlink $out/share/applications/qt6ct.desktop
          unlink $out/share/applications/kvantummanager.desktop
        '';
      })
    ];
    xdg.config.files = {
      "qt6ct/qt6ct.conf" = {
        generator = lib.generators.toINI {};
        value = {
          Appearance = {
            icon_theme = "Papirus-Dark";
            standard_dialogs = "xdgdesktopportal";
            style = "kvantum-dark";
            custom_palette = true;
          };
          Fonts = {
            fixed = ''"monospace,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"'';
            general = ''"sans-serif,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"'';
          };
        };
      };
      "Kvantum/Colors".source = "${inputs.KvLibadwaita}/src/Colors";
      "Kvantum/KvLibadwaita".source = "${inputs.KvLibadwaita}/src/KvLibadwaita";
      "Kvantum/kvantum.kvconfig" = {
        generator = lib.generators.toINI {};
        value.General.theme = "KvLibadwaitaDark";
      };
    };
    environment.sessionVariables = {
      # mate-polkit seems to read from this env var. maybe other apps too
      GTK_THEME = "adw-gtk3-dark:dark";
    };
  };
  programs.dconf.profiles.user.databases = [
    {
      lockAll = true;
      settings = {
        "org/gnome/desktop/interface" = {
          gtk-theme = "adw-gtk3-dark";
          icon-theme = "Papirus-Dark";
          font-name = "Sans Regular 11";
          document-font-name = "Sans Regular 11";
          monospace-font-name = "Monospace Regular 12";
          color-scheme = "prefer-dark";

          gtk-enable-primary-paste = false; # disable middle click paste
          enable-animations = true;
        };
        "org/gnome/desktop/wm/preferences" = {
          # hide all title bar buttons on gtk apps
          button-layout = ":";
        };
      };
    }
  ];
}
