{pkgs, ...}: {
  programs.git = {
    enable = true;
    config = {
      user = {
        name = "Teajhay";
      };
    };
  };
  programs.thunderbird.enable = true;

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
