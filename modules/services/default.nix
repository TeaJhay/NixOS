_: {
  services = {
    power-profiles-daemon.enable = true;
    lact.enable = true;
    udisks2.enable = true;
    flatpak.enable = true;
    openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = true;
        PermitRootLogin = "yes";
        KbdInteractiveAuthentication = true;
      };
    };
  };
}
