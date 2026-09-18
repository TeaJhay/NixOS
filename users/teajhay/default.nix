{
  pkgs,
  config,
  lib,
  ...
}:
let
  user = "teajhay";
  cfg = config.Host.users."${user}";
in
{
  imports = [
    ./programs/Hyprland/cursor.nix
    ./programs/Noctalia/noctalia.nix
  ];
  options.Host.users."${user}".enable = lib.mkEnableOption "the ${user} user profile";
  config = lib.mkIf cfg.enable {
    security.nix-secrets.secrets.password.neededForUsers = true;
    users.users."${user}" = {
      home = "/home/teajhay";
      isNormalUser = true;
      hashedPasswordFile = config.security.nix-secrets.secrets.password.path;
      #initialPassword = "changeme";
      description = "Tea with a side of Jhay";
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      shell = pkgs.zsh;
    };
  };
}
