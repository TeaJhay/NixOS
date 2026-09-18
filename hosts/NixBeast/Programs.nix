{ self, ... }:
{
  imports = [
  ]
  ++ map (n: "${self}/Modules/Packages/${n}") [
    "core.nix"
    "flatpak.nix"
  ];
}
