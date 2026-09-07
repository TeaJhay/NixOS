{
  description = "My NixOS config";

  inputs = {
    nix-flatpak.url = "github:gmodena/nix-flatpak"; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.
    nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05"; # NixOS release channel
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable"; # NixOS unstable channel
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master"; # NixOS hardware channel
    preservation.url = "github:nix-community/preservation";
    nix-secrets.url = "github:unnamed-systems/nix-secrets";
    import-tree.url = "github:denful/import-tree";
    niqspkgs.url = "github:diniamo/niqspkgs";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
    };
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hjem-impure = {
      url = "github:Rexcrazy804/hjem-impure";
      # these are only required for internal tests,
      # hence you can set em to nothing
      inputs.nixpkgs.follows = "";
      inputs.hjem.follows = "";
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
    findFiles = {
      url = "github:Michael-C-Buckley/findFiles.nix";
    };
    hyprland.url = "github:hyprwm/Hyprland";
  };

  nixConfig = {
    extra-substituters = [
      "https://hyprland.cachix.org"
      "https://noctalia.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  outputs =
    inputs@{
      nix-flatpak,
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-master,
      chaotic,
      disko,
      preservation,
      nixpkgs-lib,
      self,
      ...
    }: # Replaced long destructuring with clean inputs mapping

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
      overlay-master = mkChannelOverlay "master" nixpkgs-master;

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
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit self inputs; };
        modules = [
          {
            nixpkgs.overlays = [
              overlay-unstable
              overlay-master
              overlay-chaotic
            ];
          }
          ./configuration.nix
          inputs.hjem.nixosModules.default
          ./options/hjem-discovery.nix
          inputs.noctalia-greeter.nixosModules.default
          inputs.disko.nixosModules.disko
          ./hosts/disko.nix
          inputs.preservation.nixosModules.preservation
          ./options/ephemera.nix
          nix-flatpak.nixosModules.nix-flatpak
          ./options/flatpak.nix
          inputs.nix-secrets.nixosModules.default
          ./secrets/secrets.nix
        ];
      };
    };
}
