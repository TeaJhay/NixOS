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

  system.stateVersion = "26.05"; # DO NOT TOUCH

  boot = {
    loader.systemd-boot.enable = true;
    initrd.systemd.emergencyAccess = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_zen; # Use zen OR latest kernel.
    initrd.kernelModules = [ "amdgpu" ];
    kernelParams = [
      #"video=DP-1:1920x1080@60"
      #"video=HDMI-A-1:3840x2160@120"
    ];
  };

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
