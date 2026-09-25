_: {
  #imports = [
  #  ./config.nix
  #];

  nix.settings = {
    substituters = [
      "https://noctalia.cachix.org"
    ];
    trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
    trusted-users = [
      "root"
      "@wheel"
    ];
  };

  services.displayManager.noctalia-greeter = {
    enable = true;
    settings = {
      session.default = "hyprland";
    };
  };
}
