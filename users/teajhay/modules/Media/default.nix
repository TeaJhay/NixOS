{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    pear-desktop
    krita
    udiskie
    oculante
    onlyoffice-desktopeditors
    xdg-desktop-portal-termfilechooser
    stremio-linux-shell
  ];
}
