{ inputs, ... }:
let
  nixos-hardware = inputs.nixos-hardware;
in
{
  imports = [
    ./Disko.nix
    ./Filesystem.nix
    ./Hardware-Configuration.nix
    ./Programs.nix
    nixos-hardware.nixosModules.common-cpu-amd # common AMD cpu settings
    nixos-hardware.nixosModules.common-cpu-amd-pstate # Common AMD cpu pstate settings
    #nixos-hardware.nixosModules.common-cpu-amd-zenpower # Replaces kernel sensing with zenpower - out of date
    nixos-hardware.nixosModules.common-gpu-amd # gpu settings
    nixos-hardware.nixosModules.gigabyte-b650 # motherboard fix
  ];
}
