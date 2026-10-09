{
  description = "My Slice of Hell";

  outputs = {self, ...} @ args: let
    inputs = (import ./.tack) {
      overrides = args.tackOverrides or {};
    };
  in
    with inputs; let
      # Modules shared by every host
      commonModules = [
        ({config, ...}: {
          nixpkgs.overlays = [
            millennium.overlays.default # Millenium overlay for steam
          ];
          documentation.enable = false;
          # make a symlink of flake within the generation (e.g. /run/current-system/src)
          system.systemBuilderCommands = "ln -s ${self.sourceInfo.outPath} $out/src";
          disabledModules = ["programs/tack.nix"];
          nix.channel.enable = false;
          nix = {
            extraOptions = ''
              !include ${config.security.nix-secrets.secrets."gh-token".path}
            '';
            settings = {
              auto-allocate-uids = true;
              auto-optimise-store = true;
              use-cgroups = true;
              experimental-features = [
                "auto-allocate-uids"
                "cgroups"
                "flakes"
                "nix-command"
                # "pipe-operator"
              ];
              substituters = [
                "https://cache.doesntcompute.site/nix-cache"
                "https://nix-community.cachix.org"
              ];
              trusted-public-keys = [
                "cache.doesntcompute.site:S6YA1haeQJ97lrvFMflyFur4+Tssfu7jc7d233Fd87I="
                "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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
