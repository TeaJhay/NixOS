{ self, ... }:
{
  imports = [
  ]
  ++ map (n: "${self}/Modules/Packages/${n}.nix") [
    "Core"
    "Flatpak"
    "PrismLauncher"
    "Gaming"
  ];
}
