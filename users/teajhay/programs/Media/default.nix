{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    unstable.pear-desktop
    krita
    udiskie
    loupe
  ];
}
