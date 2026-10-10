{pkgs, ...}: {
  programs = {
    git = {
      enable = true;
      config = {
        user = {
          name = "Teajhay";
        };
      };
    };
    thunderbird.enable = true;
    tack = {
      enable = true;
      nixConfTokens = true;
    };
  };
  #       ┌─────────────────────────┐
  #       │         Packages        │
  #       └─────────────────────────┘
  services.headscale.settings.warnings = ["The `foo' service is deprecated and will go away soon!"];
  environment.systemPackages = with pkgs; [
    gcc
    nixd
    python3
    gnumake
  ];
}
