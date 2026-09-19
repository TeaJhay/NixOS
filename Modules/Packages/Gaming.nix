{ pkgs, ... }:
{

  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    protontricks.enable = true;
    package = pkgs.millennium-steam;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  hardware = {
    bluetooth.enable = true;
  };

  environment.systemPackages = with pkgs; [
    heroic
    protonplus
  ];

  boot.kernelModules = [
    "ntsync"
  ];
  services.udev.extraRules = ''
    KERNEL=="ntsync", MODE="0644"
  '';

    environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "\${HOME}/.steam/root/compatibilitytools.d";
  };
}
