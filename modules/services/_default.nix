
  services = {
    power-profiles-daemon.enable = true;
    lact.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true; # Optional: enable if you use JACK
    };
  };
