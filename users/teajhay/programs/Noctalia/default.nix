{ ... }:
{
  #imports = [
  #  ./config.nix
  #];

  nix.settings = {
    trusted-substituters = [
      "https://noctalia.cachix.org"
    ];
    trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
    # Required so non-root users are allowed to use the above substituter/keys.
    # Use @wheel for all sudo users, or list your username explicitly.
    trusted-users = [
      "root"
      "@wheel"
    ];
  };

  programs.noctalia-greeter = {
    enable = true;
    settings = {
      session.default = "hyprland";
    };
  };

}
