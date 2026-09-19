{
  inputs,
  pkgs,
  ...
}:
let
  nixos-hardware = inputs.nixos-hardware;
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

  services.power-profiles-daemon.enable = true;
  services.lact.enable = true;

  #       ┌─────────────────────────┐
  #       │          Sound          │
  #       └─────────────────────────┘

  security.rtkit.enable = true;
  services.pipewire = {
    # Enable sound.
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
