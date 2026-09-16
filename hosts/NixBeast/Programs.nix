{ self, ... }:
{
  imports = [
    ] ++ map (n: "${self}/Modules/Packages/${n}") [
      "Hyprland"
      "core.nix"
      "flatpak.nix"
    ];
}
