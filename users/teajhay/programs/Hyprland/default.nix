{
  inputs,
  pkgs,
  ...
}: {
  #imports = [
  #  ./cursor.nix
  #];
  #nix.settings = {
  #  substituters = [
  #    "https://hyprland.cachix.org"
  #  ];
  #  trusted-substituters = [
  #    "https://hyprland.cachix.org"
  #  ];
  #  trusted-public-keys = [
  #    "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
  #  ];
  #  # Required so non-root users are allowed to use the above substituter/keys.
  #  # Use @wheel for all sudo users, or list your username explicitly.
  #  trusted-users = [
  #    "root"
  #    "@wheel"
  #  ];
  #};

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    withUWSM = false;
    xwayland.enable = true;
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Optional, hint Electron apps to use Wayland:

  environment.systemPackages = with pkgs; [
    hyprcursor
    playerctl
    unstable.quickshell
    qt6.qtwayland
  ];
}
