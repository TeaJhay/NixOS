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
  hardware.uinput.enable = true;
  hardware.steam-hardware.enable = true;
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    heroic
    protonplus
  ];

  boot.kernelModules = [
    "ntsync"
    "hid-playstation"
  ];
  services.udev = {
    packages = with pkgs; [
      game-devices-udev-rules
    ];
    extraRules = ''
      KERNEL=="ntsync", MODE="0644"
      ATTRS{name}=="DualSense Edge Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
      ATTRS{name}=="Sony Interactive Entertainment DualSense Edge Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    '';
  };
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };
}
