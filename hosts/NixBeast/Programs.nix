{ self, ... }:
{
  imports = [
  ]
  ++ map (n: "${self}/Modules/Packages/${n}.nix") [
    "core"
    "flatpak"
    "PrismLauncher"
  ];
}
