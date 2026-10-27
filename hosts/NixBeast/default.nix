{
  inputs,
  self,
  ...
}: let
  inherit (inputs) nixos-hardware;
  commonModules = with inputs; [
    ({config, ...}: {
      nixpkgs.overlays = [
        millennium.overlays.default # Millenium overlay for steam
      ];
      documentation.enable = false;
      # make a symlink of flake within the generation (e.g. /run/current-system/src)
      system.systemBuilderCommands = "ln -s ${self.sourceInfo.outPath} $out/src";
      disabledModules = ["programs/tack.nix"];
      nix = {
        channel.enable = false;
        extraOptions = ''
          !include ${config.security.nix-secrets.secrets."gh-token".path}
        '';
        settings = {
          auto-allocate-uids = true;
          auto-optimise-store = true;
          use-cgroups = true;
          experimental-features = [
            "auto-allocate-uids"
            "flakes"
            "nix-command"
            "pipe-operators"
          ];
          substituters = [
            "https://cache.doesntcompute.site/nix-cache"
            "https://nix-community.cachix.org"
            "https://cache.manic.systems"
          ];
          trusted-public-keys = [
            "cache.doesntcompute.site:peri6vDK6y7aPih0zdRdSbOJ+nAOv7BVY1DqRsqyuc8="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "cache.manic.systems-1:s6OZanN8Us8vRi0jVivP3qlMn0cYHBjBALKrNe5nH8s="
          ];
          trusted-users = [
            "root"
            "@wheel"
          ];
        };
      };

      programs = {
        nh = {
          enable = true;
          clean.enable = true;
          clean.extraArgs = "--keep-since 5d --keep 20";
          flake = "/persistent/home/teajhay/nixos"; # sets NH_OS_FLAKE variable for you
        };
      };
    }) # Modules from inputs that get used.
    hjem.nixosModules.default
    noctalia-greeter.nixosModules.default
    disko.nixosModules.disko
    preservation.nixosModules.preservation
    nix-flatpak.nixosModules.nix-flatpak
    inputs.nix-secrets.nixosModules.default
    inputs.tack.nixosModules.default
    nixos-core.nixosModules.default
    {system.nixos-core.enable = true;}
  ];
in {
  imports =
    commonModules
    ++ [
      ./Disko.nix
      ./Hardware-Configuration.nix
      ./Programs.nix
      ./Hacking.nix
      "${self}/Modules/Filesystem"
      nixos-hardware.nixosModules.common-cpu-amd # common AMD cpu settings
      nixos-hardware.nixosModules.common-cpu-amd-pstate # Common AMD cpu pstate settings
      #nixos-hardware.nixosModules.common-cpu-amd-zenpower # Replaces kernel sensing with zenpower - out of date
      nixos-hardware.nixosModules.common-gpu-amd # gpu settings
      nixos-hardware.nixosModules.gigabyte-b650 # motherboard fix
    ];
  config = {
    system.nixos.label = self.shortRev or self.dirtyShortRev or "unknown";
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

    nixpkgs.hostPlatform = "x86_64-linux";
    nixpkgs.config.allowUnfree = true;
    #       ┌─────────────────────────┐
    #       │          Users          │
    #       └─────────────────────────┘

    hardware.enableRedistributableFirmware = true;

    security.rtkit.enable = true;
  };
}
