{
  description = "My Slice of Hell";

  outputs = {self, ...} @ args: let
    inputs = (import ./.tack) {
      overrides = args.tackOverrides or {};
    };
  in
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
      # Modules shared by every host
      commonModules = [
        {
          nixpkgs.overlays = [
            overlay-unstable # Prefix package with "unstable." to use unstable package
            millennium.overlays.default # Millenium overlay for steam
          ];
          nix.settings.experimental-features = [
            # Enabled flakes and nix-command systemwide.
            "nix-command"
            "flakes"
          ];
          nix.settings = {
            substituters = [
              "https://cache.doesntcompute.site/nix-cache"
              "https://nix-community.cachix.org"
            ];
            trusted-public-keys = [
              "cache.doesntcompute.site:S6YA1haeQJ97lrvFMflyFur4+Tssfu7jc7d233Fd87I="
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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
      packages.x86_64-linux = self.nixosConfigurations.NixBeast.config.system.build.toplevel;
    };
}
