/*

Make this an option where users can be declared in a list, and then map each user to some sane defaults.
*/
{
  lib,
  config,
  inputs,
  self,
  ...
}: let
  inherit (lib) mkOption mkIf mapAttrs mkEnableOption;
  inherit (lib.types) enum attrsOf submodule;
  inherit (inputs.findFiles) findFiles;
  cfg = config.host.system;

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
  options.host = {
    system = {
      enable = mkEnableOption "machine configuration";
      users = mkOption {
        description = "List of machine users and their respective roles.";
        default = [];

        type = attrsOf (submodule {
          options.role = mkOption {
            type = enum ["admin" "user"];
            default = "user";
            description = "User's role on the machine.";
          };
        });
      };
      unfreeSoftware = mkEnableOption {
        default = false;
        description = "allow unfree software";
      };
    };
  };

  config = mkIf cfg.enable {
    #System users
    users.users =
      mapAttrs (_: user: {
        isNormalUser = true;
        extraGroups = lib.optional (user.role == "admin") "wheel";
      })
      cfg.users;
    #hostPlatform
    nixpkgs.hostPlatform = cfg.hardware.platform;

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
            dotsDir = "${self}/hosts/${config.system.name}/${name}/xdg";
            dotsDirImpure = "${self}/hosts/${config.system.name}/users/${name}/xdg";
          };
          clobberFiles = true;
        })
        cfg.users;
    };
    system.nixos.label = self.shortRev or self.dirtyShortRev or "unknown";
    nixpkgs.config.allowUnfree = cfg.unfreeSoftware;
  };
}
