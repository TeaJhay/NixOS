{
  description = "My NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05"; # NixOS release channel
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable"; # NixOS unstable channel
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master"; # NixOS hardware channel
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    update = {
      url = "github:ryantm/nixpkgs-update";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-monitored = {
      url = "github:ners/nix-monitored";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixd = {
      url = "github:nix-community/nixd";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fan-controller = {
      url = "github:Krutonium/BetterFanController";
      inputs.nixpkgs.follows = "nixpkgs";
    };
#    nur = {
#      url = "github:nix-community/NUR";
#      # inputs.nixpkgs.follows = "nixpkgs"; NUR does not.
#    };
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    };
    hyprland.url = "github:hyprwm/Hyprland";
  };



outputs = inputs@{ nixpkgs, nixpkgs-unstable, nixpkgs-master, chaotic, ... }: # Replaced long destructuring with clean inputs mapping
    let
      system = "x86_64-linux";

      # Generic helper: turn a nixpkgs-like flake input into an overlay
      # that exposes it as pkgs.<name>
      mkChannelOverlay = name: flakeInput: final: prev: {
        ${name} = import flakeInput {
          inherit system;
          config.allowUnfree = true;
        };
      };

      overlay-unstable = mkChannelOverlay "unstable" nixpkgs-unstable;
      overlay-master   = mkChannelOverlay "master" nixpkgs-master;

      # Chaotic-Nyx isn't its own nixpkgs — it's an *overlay* meant to sit on
      # top of nixpkgs-unstable. So we build a pkgs set with their overlay
      # applied, then namespace the whole thing under pkgs.chaotic
      overlay-chaotic = final: prev: {
        chaotic = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
          overlays = [ chaotic.overlays.default ];
        };
      };
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          {
            nixpkgs.overlays = [
              overlay-unstable
              overlay-master
              overlay-chaotic
            ];
          }
          inputs.noctalia-greeter.nixosModules.default
          ./configuration.nix
        ];
      };
    };
}

