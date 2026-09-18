{
  pkgs,
  config,
  lib,
  ...
}:
let
  user = "<Fill here>";
  cfg = config.Host.users."${user}";
in
{
  options.Host.users."${user}".enable = lib.mkEnableOption "the ${user} user profile";

  config = lib.mkIf cfg.enable {
    security.nix-secrets.secrets.password.neededForUsers = true;
    users.users."${user}" = {
      home = "/home/${user}";
      isNormalUser = true;
      hashedPasswordFile = config.security.nix-secrets.secrets."${user}-password".path;
      #initialPassword = "changeme";
      description = "<Fill here>";
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      shell = pkgs.zsh;
    };
  };
}
