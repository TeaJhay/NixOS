{pkgs, config, self, ... }:
{  # ... your config

  # Configure nix-flatpak
  services.flatpak = {
    enable = true;
    packages = [
      "com.github.tchx84.Flatseal"
      "org.telegram.desktop"
    ];
  };
}
