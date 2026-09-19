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
    ./programs/Noctalia
    ./programs/Hyprland
    ./programs/OpenLinkHub
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
    fonts.enableDefaultPackages = true;
    fonts.packages = with pkgs; [
      ibm-plex
      nerd-fonts.iosevka
    ];

    fonts.fontconfig = {
      defaultFonts = {
        serif = [ "IBM Plex Serif" ];
        sansSerif = [ "IBM Plex Sans" ];
        monospace = [ "Iosevka Nerd Font" ];
      };
    };

    environment.sessionVariables = {
      EDITOR = "nvim";
      STARSHIP_CONFIG = "/home/teajhay/.config/starship/starship.toml";
      NIXOS_CONFIG = "/persistent/home/teajhay/nixos/";
    };

  };
}
