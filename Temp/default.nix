_: {
  imports = [
    ./Core.nix
    ./Flatpak.nix
    ./Gaming.nix
    ./Mobile.nix
    ./PrismLauncher.nix
  ];
  environment.etc."machine-id".text = "02593cf2c06c4f61836f38cc685434a5";
}
