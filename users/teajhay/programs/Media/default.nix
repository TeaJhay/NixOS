{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    pear-desktop
    krita
    udiskie
    loupe
    onlyoffice-desktopeditors
  ];
}
