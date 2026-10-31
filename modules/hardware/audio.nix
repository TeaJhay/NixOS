{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.host.system.hardware) modules;
  inherit (lib) mkIf mkMerge;
  inherit (lib.lists) elem any;
  inherit (lib.strings) hasPrefix;
in {
  # For setting headphone clock rates
  config = mkIf (any (s: hasPrefix "audio" s) modules) (mkMerge [
    {
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
      environment.systemPackages = [pkgs.at-spi2-core];
      security.rtkit.enable = true;
      users.extraGroups = [
        "audio"
        "pipewire"
      ];
      services.pulseaudio.enable = lib.mkForce false;
      boot.kernelModules = ["snd_usb_audio"];
    }

    (mkIf (elem "audio/realtime" modules) {
      services.pipewire = {
        wireplumber.enable = true;
        extraConfig.pipewire."10-adjust-allowed-rates" = {
          "context.properties"."default.clock.allowed-rates" = [
            44100
            48000
            88200
            96000
            176400
            352800
            384000
          ];
        };
      };
      boot = {
        kernel.sysctl."vm.swappiness" = 10;
        kernelParams = ["threadirqs"];
      };

      services.udev.extraRules = ''
        KERNEL=="rtc0", GROUP="audio"
        KERNEL=="hpet", GROUP="audio"
      '';
    })
  ]);
}
