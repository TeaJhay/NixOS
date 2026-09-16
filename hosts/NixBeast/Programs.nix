{ self, ... }:
{
  imports = [
  ]
  ++ map (n: "${self}/Modules/Packages/${n}") [
    "Hyprland"
    "Noctalia"
    "core.nix"
    "flatpak.nix"
  ];
}
