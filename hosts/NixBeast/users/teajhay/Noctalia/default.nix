{pkgs, ...}: {
  services = {
    power-profiles-daemon.enable = true;
    displayManager.noctalia-greeter = {
      enable = true;
      settings = {
        session.default = "hyprland";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    greetd
  ];
}
