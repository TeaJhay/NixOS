{
  pkgs,
  lib,
  ...
}: let
  # https://github.com/hunkyburrito/xdg-desktop-portal-termfilechooser
  termfilechooser = pkgs.xdg-desktop-portal-termfilechooser;
  filemanager = pkgs.org-freedesktop-filemanager1-common;
in {
  xdg.portal = {
    enable = true;
    # https://github.com/NixOS/nixpkgs/issues/160923
    xdgOpenUsePortal = true;
    extraPortals = [termfilechooser filemanager];
  };

  hjem.extraModules = lib.singleton {
    # be sure to realise hjem env vars yourself!
    environment.sessionVariables = {
      GDK_DEBUG = "portals";
      # deprecated, but still required by some GTK applications
      # https://gitlab.gnome.org/GNOME/gtk/-/merge_requests/4829
      GTK_USE_PORTAL = 1;
    };
  };
  hjem.users.teajhay = {
    xdg.config.files = {
      "org.freedesktop.FileManager1.common/config" = {
        generator = lib.generators.toINIWithGlobalSection {};
        value.globalSection.cmd = pkgs.substitute {
          src = "${pkgs.org-freedesktop-filemanager1-common}/share/org.freedesktop.FileManager1.common/yazi-wrapper.sh";
          substitutions = [
            # you could also replace `cmd="yazi"` here
            "--replace-fail"
            ''termcmd="''${TERMCMD:-/usr/bin/kitty --class yazi}"''
            ''termcmd="''${TERMCMD:-${
                lib.getExe pkgs.kitty
              }}"''
          ];
          postInstall = ''
            chmod +x "$out"
          '';
        };
      };
      "xdg-desktop-portal/portals.conf" = {
        text = ''
          [preferred]
          default=gtk
          org.freedesktop.impl.portal.FileChooser=termfilechooser
        '';
      };
      "xdg-desktop-portal-termfilechooser/config" = {
        text = ''
          [filechooser]
          cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
          env=TERMCMD=kitty --class filechooser -T terminal-filechooser
        '';
      };
    };
  };
}
