{
  inputs,
  ...
}:
let
  inherit (inputs) nixos-hardware;
in
{
  nixpkgs.config.allowUnfree = true;
  imports = [
    ./Disko.nix
    ./Hardware-Configuration.nix
    ./Programs.nix
    ./Hacking.nix
    ./Users.nix
    nixos-hardware.nixosModules.common-cpu-amd # common AMD cpu settings
    nixos-hardware.nixosModules.common-cpu-amd-pstate # Common AMD cpu pstate settings
    #nixos-hardware.nixosModules.common-cpu-amd-zenpower # Replaces kernel sensing with zenpower - out of date
    nixos-hardware.nixosModules.common-gpu-amd # gpu settings
    nixos-hardware.nixosModules.gigabyte-b650 # motherboard fix
  ];
services = {

  power-profiles-daemon.enable = true;
  lact.enable = true;
  pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true; # Optional: enable if you use JACK
  };
};

  #       ┌─────────────────────────┐
  #       │          Sound          │
  #       └─────────────────────────┘
  hardware.enableAllFirmware = true;

  security.rtkit.enable = true;
}
