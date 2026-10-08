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

  environment.systemPackages = with pkgs; [
    gcc
    nixd
    python3
    gnumake
  ];
}
