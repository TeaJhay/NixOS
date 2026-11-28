/*

Make this an option where users can be declared in a list, and then map each user to some sane defaults.
*/
{
  lib,
  pkgs,
  config,
  inputs,
  self,
  ...
}: let
  inherit (lib) mkOption mkIf mapAttrs mkEnableOption;
  inherit (lib.types) enum attrsOf submodule;
  inherit (inputs.findFiles) findFiles;
  cfg = config.sys;
  secrets = config.security.nix-secrets.secrets;
  getUserDotfiles = username: let
    # declares the function "getUserDotfiles" and parameter "username"
    dotfilesDir = "${self}/hosts/${config.system.name}/users/${username}/xdg/"; # sets the users dotfilees directory using the previously declared usersDir plus the structured path with their username as the parameter given by calling function.
  in
    if builtins.pathExists dotfilesDir # checks if the path exists
    then findFiles dotfilesDir # uses findFiles to return every file in the users dotfiles directory
    else {};
in {
  imports = [
    inputs.hjem.nixosModules.default
  ];
  options.sys = {
    enable = mkEnableOption "Host configuration module";
    users = mkOption {
      description = "Users on this host";
      type = attrsOf (submodule {
        options.role = mkOption {
          type = enum ["admin" "user"];
          default = "user";
          description = "User's role on this host";
        };
      });
    };

    role = mkOption {
      description = "Hardware role of this host";
      type = enum ["desktop" "kvm-virt" "lxc-virt" "server" "laptop"];
    };
    platform = mkOption {
      type = enum [
        "x86_64-linux"
        "aarch64-linux"
        "i686-linux"
        "armv7l-linux"
      ];
      default = null;
      description = "Platform architecture of this host";
    };
    unfreeSoftware = mkEnableOption {
      default = false;
      description = "Allow unfree software on this host";
    };
    services = mkOption {
      description = "Services on this host";
      type = attrsOf (submodule {
        options.enable = mkEnableOption "Enable this service";
      });
    };
  };

  config = mkIf cfg.enable {
    #System users
    users.users =
      mapAttrs (name: user: {
        isNormalUser = true;
        extraGroups = lib.optional (user.role == "admin") "wheel";
        hashedPasswordFile = secrets."${name}/password".path;
      })
      cfg.users;
    #hostPlatform
    nixpkgs.hostPlatform = cfg.platform;
    nix.settings = {
      experimental-features = [
        "flakes"
        "nix-command"
        "pipe-operators"
      ];
    };
    programs = {
      nh = {
        enable = true;
        package = inputs.nh.packages.${pkgs.stdenv.hostPlatform.system}.default;
        clean = {
          enable = true;
          extraArgs = "--keep-since 5d --keep 20";
        };
        flake = "/persistent/home/teajhay/nixos"; # sets NH_OS_FLAKE variable for you
      };
      tack = {
        enable = true;
        nixConfTokens = true;
      };
    };

    # Hjem files
    hjem = {
      extraModules = [
        inputs.hjem-impure.hjemModules.default
        inputs.hjem-rum.hjemModules.default
      ];
      users =
        mapAttrs (name: _: {
          enable = true;
          user = name;
          directory = config.users.users.${name}.home;
          files = getUserDotfiles name;
          impure = {
            enable = true;
            dotsDir = "${self}/hosts/${config.system.name}/users/${name}/xdg";
            dotsDirImpure = "${self}/hosts/${config.system.name}/users/${name}/xdg";
          };
          clobberFiles = true;
          rum.programs = {
            direnv = {
              enable = true;
              integrations = {
                zsh.enable = true;
                nix-direnv.enable = true;
              };
            };
          };
        })
        cfg.users;
    };
    system.stateVersion = config.system.nixos.release;
    system.nixos.label = self.shortRev or self.dirtyShortRev or "unknown";
    nixpkgs.config.allowUnfree = cfg.unfreeSoftware;
  };
}
