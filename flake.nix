{
  description = "My Slice of Hell";
  #       ┌─────────────────────────┐
  #       │       Flake Inputs      │
  #       └─────────────────────────┘
  inputs = {
    nix-flatpak.url = "github:gmodena/nix-flatpak"; # NOTE: to use nix-flatpak to declartively load flatpaks.
    nixpkgs-lib.url = "github:nix-community/nixpkgs.lib"; # NOTE: some special nix lib stuff.
    nixpkgs.url = "https://channels.nixos.org/nixos-26.05/nixexprs.tar.zst"; # NOTE: NixOS release channel - where packages come from by default
    nixpkgs-unstable.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst"; # NixOS unstable channel - prefix pkg with "unstable." to pull from here
    #nixpkgs-master.url = "github:NixOS/nixpkgs/master"; # NOTE: Master branch, use this for packages that haven't even been tested for use in unstable. Commented out as heavy.
    nixos-hardware.url = "github:NixOS/nixos-hardware/master"; # NOTE: NixOS hardware channel - some common hardware settings
    preservation.url = "github:nix-community/preservation"; # NOTE: Module for preserving folders/files for ephemeral root/impermanence setup.
    import-tree.url = "github:denful/import-tree"; # NOTE: Use to import all .nix files in directories tree.
    #chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable"; # NOTE: Handful of packages and options using git, instead of waiting for nixpkgs
    findFiles.url = "github:Michael-C-Buckley/findFiles.nix"; # NOTE: findFiles utility to recursively return an attrset of files from a path for hjem or preservation.
    niqspkgs = {
      url = "github:diniamo/niqspkgs"; # NOTE: Some self-maintained derivations by diniamo
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    millennium = {
      url = "github:SteamClientHomebrew/Millennium?dir=packages/nix"; # NOTE: Steam customisation framework
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-secrets = {
      url = "github:unnamed-systems/nix-secrets"; # NOTE: Secrets in nix!
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter"; # NOTE: Greeter, like SDDM or Tuigreet but... Noctalia <3
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix"; # NOTE: Noctalia... Replacement shell/System for waybar, launcher, notifs, widgets, lock and etc. (also umbriel but... blegh)
    };
    hyprland = {
      url = "github:hyprwm/Hyprland"; # NOTE: Tiling window manager/Compositor
    };
    disko = {
      # NOTE: Disk partitioning, formatting and declaring tool.
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      # NOTE: Zen browser - Firefox but "A calmer way"
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hjem = {
      # NOTE: lightweight user home managment module, to replace Home-Manager (means "home" in danish)
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hjem-rum = {
      url = "github:snugnug/hjem-rum";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hjem.follows = "hjem";
    };
    hjem-impure = {
      # NOTE: Hjem but impure. Use to symlink persistent dotfiles to ephemereral home and edit. Can't add folders or files.
      url = "github:Rexcrazy804/hjem-impure";
      inputs.nixpkgs.follows = "";
      inputs.hjem.follows = "";
    };
    #update = {
    ## WARN: Not sure why I have this, seems to allow you to send a PR to update a package to a new commit?
    #  url = "github:ryantm/nixpkgs-update";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    #nix-monitored = { # WARN: Removed in favour of NH
    #  # pretty output for nix rebuild.
    #  url = "github:ners/nix-monitored";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    #nur = {
    ## WARN: Basically AUR but Nix, avoid.
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
      #overlay-chaotic = final: prev: {
      #  chaotic = import nixpkgs-unstable {
      #    system = prev.stdenv.hostPlatform.system;
      #    config.allowUnfree = true;
      #    overlays = [chaotic.overlays.default];
      #  };
      #};
      # Modules shared by every host
      commonModules = [
        {
          nixpkgs.overlays = [
            overlay-unstable # Prefix package with "unstable." to use unstable package
            #overlay-master # Prefix package with "master." to use unstable package
            #overlay-chaotic # Prefix package with "chaotic." to use unstable package
            millennium.overlays.default # Millenium overlay for steam
            #inputs.nix-monitored.overlays.default # Nix monitored overlay for pretty Nix command outputs
          ];
          #({pkgs, ...}: {
          #  nix.package = pkgs.nix-monitored;
          #})
          nix.settings.experimental-features = [
            # Enabled flakes and nix-command systemwide.
            "nix-command"
            "flakes"
          ];
          nix.settings = {
            substituters = [
              "https://cache.nixos.org"
              "https://cache.doesntcompute.site"
            ];
            trusted-public-keys = [
              "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
              "ci.example.org-1:XXO/7m4jOmYrZg0TGZYNd6EBuBfVjPwZXYnABK6yTRc="
            ];
          };
          documentation.enable = false;
          # make a symlink of flake within the generation (e.g. /run/current-system/src)
          system.systemBuilderCommands = "ln -s ${self.sourceInfo.outPath} $out/src";
          programs.nh = {
            enable = true;
            clean.enable = true;
            clean.extraArgs = "--keep-since 5d --keep 20";
            flake = "/persistent/home/teajhay/nixos"; # sets NH_OS_FLAKE variable for you
          };
        } # Modules from inputs that get used.
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
