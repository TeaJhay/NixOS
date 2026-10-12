{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    pear-desktop
    krita
    udiskie
    loupe
    onlyoffice-desktopeditors
    xdg-desktop-portal-termfilechooser
    stremio-linux-shell
  ];
}
