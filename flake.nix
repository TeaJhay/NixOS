{
  description = "My Slice of Hell";
  #       ┌─────────────────────────┐
  #       │       Flake Inputs      │
  #       └─────────────────────────┘
  inputs = {
    nix-flatpak.url = "github:gmodena/nix-flatpak"; # to use nix-flatpak to declartively load flatpaks.
    nixpkgs-lib.url = "github:nix-community/nixpkgs.lib"; # some special nix lib stuff.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05"; # NixOS release channel - where packages come from by default
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable"; # NixOS unstable channel - prefix pkg with "unstable." to pull from here
    #nixpkgs-master.url = "github:NixOS/nixpkgs/master"; # Master branch, use this for packages that haven't even been tested for use in unstable. Commented out as heavy.
    nixos-hardware.url = "github:NixOS/nixos-hardware/master"; # NixOS hardware channel - some common hardware settings
    preservation.url = "github:nix-community/preservation"; # Module for preserving folders/files for ephemeral root/impermanence setup.
    nix-secrets.url = "github:unnamed-systems/nix-secrets"; # Secrets in nix!
    import-tree.url = "github:denful/import-tree"; # Use to import all .nix files in directories tree.
    niqspkgs.url = "github:diniamo/niqspkgs"; # Some self-maintained derivations by diniamo
    millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix"; # Steam customisation framework
    hyprland.url = "github:hyprwm/Hyprland";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable"; # Handful of packages and options using git, instead of waiting for nixpkgs
    findFiles.url = "github:Michael-C-Buckley/findFiles.nix"; # findFiles utility to recursively return an attrset of files from a path for hjem or preservation.
    noctalia-greeter.url = "github:noctalia-dev/noctalia-greeter"; # Greeter, like SDDM or Tuigreet but... Noctalia <3
    noctalia.url = "github:noctalia-dev/noctalia/cachix"; # Noctalia... Replacement shell/System for waybar, launcher, notifs, widgets, lock and etc. (also umbriel but... blegh)
    nvf = {
      # neo-vim framework for Nix - Rafware
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    disko = {
      # Disk partitioning, formatting and declaring tool.
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      # Zen browser - Firefox but "A calmer way"
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hjem = {
      # lightweight user home managment module, to replace Home-Manager (means "home" in danish)
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hjem-impure = {
      # Hjem but impure. Use to symlink persistent dotfiles to ephemereral home and edit. Can't add folders or files.
      url = "github:Rexcrazy804/hjem-impure";
      inputs.nixpkgs.follows = "";
      inputs.hjem.follows = "";
    };
    update = {
      # Not sure why I have this, seems to allow you to send a PR to update a package to a new commit?
      url = "github:ryantm/nixpkgs-update";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-monitored = {
      # pretty output for nix rebuild.
      url = "github:ners/nix-monitored";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #nur = {
    ## Basically AUR but Nix, avoid.
    #  url = "github:nix-community/NUR";
    #};
  };
  #       ┌─────────────────────────┐
  #       │      Flake Outputs      │
  #       └─────────────────────────┘
  outputs = inputs @ {self, ...}:
  # Replaced long destructuring with clean inputs mapping
    with inputs; let
      # Generic helper: turn a nixpkgs-like flake input into an overlay
      # that exposes it as pkgs.<name>
      mkChannelOverlay = name: flakeInput: final: prev: {
        ${name} = import flakeInput {
          system = prev.stdenv.hostPlatform.system;
          config.allowUnfree = true;
        };
      };
      overlay-unstable = mkChannelOverlay "unstable" nixpkgs-unstable;
      #overlay-master = mkChannelOverlay "master" nixpkgs-master;
      # Chaotic-Nyx isn't its own nixpkgs — it's an *overlay* meant to sit on
      # top of nixpkgs-unstable. So we build a pkgs set with their overlay
      # applied, then namespace the whole thing under pkgs.chaotic
      overlay-chaotic = final: prev: {
        chaotic = import nixpkgs-unstable {
          system = prev.stdenv.hostPlatform.system;
          config.allowUnfree = true;
          overlays = [chaotic.overlays.default];
        };
      };
      # Modules shared by every host
      commonModules = [
        {
          nixpkgs.overlays = [
            overlay-unstable # Prefix package with "unstable." to use unstable package
            #overlay-master # Prefix package with "master." to use unstable package
            overlay-chaotic # Prefix package with "chaotic." to use unstable package
            millennium.overlays.default # Millenium overlay for steam
            inputs.nix-monitored.overlays.default # Nix monitored overlay for pretty Nix command outputs
          ];
        }
        ({pkgs, ...}: {
          nix.package = pkgs.nix-monitored;
        })
        {
          nix.settings.experimental-features = [
            # Enabled flakes and nix-command systemwide.
            "nix-command"
            "flakes"
          ];
        }
        {
          nix.gc = {
            # Default garbage collection
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 14d";
          };
        }
        # Modules from inputs that get used.
        hjem.nixosModules.default
        noctalia-greeter.nixosModules.default
        disko.nixosModules.disko
        preservation.nixosModules.preservation
        nix-flatpak.nixosModules.nix-flatpak
        inputs.nix-secrets.nixosModules.default
        #(_: { # SUPPOSED to label the generation with the commit... but doesn't.
        #  system.nixos.label = self.shortRev or self.dirtyShortRev or "unknown";
        #})
      ];

      # Helper for making hosts.
      mkHost = {
        path,
        system ? "x86_64-linux",
        extraModules ? [],
      }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {inherit self inputs;};
          modules = commonModules ++ [path] ++ extraModules;
        };
    in {
      nixosConfigurations = {
        # Hosts!
        NixBeast = mkHost {path = ./hosts/NixBeast;};
        # Laptop = mkHost {path = ./hosts/Laptop;};
      };
    };
}
