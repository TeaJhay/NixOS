{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  user = "teajhay";
  cfg = config.Host.users."${user}";
in {
  imports = [
    (inputs.import-tree ./programs)
  ];
  options.Host.users."${user}".enable = lib.mkEnableOption "the ${user} user profile";
  #       ┌─────────────────────────┐
  #       │       User config       │
  #       └─────────────────────────┘
  config = lib.mkIf cfg.enable {
    security.nix-secrets.secrets.password.neededForUsers = true;
    users.users."${user}" = {
      home = ''/home/${user}'';
      isNormalUser = true;
      hashedPasswordFile = config.security.nix-secrets.secrets.password.path;
      #initialPassword = "changeme";
      description = "Tea with a side of Jhay";
      extraGroups = [
        "wheel"
        "networkmanager"
        "input"
      ];
      shell = pkgs.zsh;
    };
    #       ┌─────────────────────────┐
    #       │          Fonts          │
    #       └─────────────────────────┘
    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        ibm-plex
        nerd-fonts.iosevka
      ];

      fontconfig = {
        defaultFonts = {
          serif = ["IBM Plex Serif"];
          sansSerif = ["IBM Plex Sans"];
          monospace = ["Iosevka Nerd Font"];
        };
      };
    };

    #       ┌─────────────────────────┐
    #       │      Nix Profiles       │
    #       └─────────────────────────┘
    systemd.tmpfiles.rules = [
      "L+ /home/'${user}'/.nix-profile - - - - .local/state/nix/profiles/profile"
    ];
    #       ┌─────────────────────────┐
    #       │        Env Vars         │
    #       └─────────────────────────┘
    environment.sessionVariables = {
      EDITOR = "nvim";
      STARSHIP_CONFIG = "/home/${user}/.config/starship/starship.toml";
      NIXOS_CONFIG = "/persistent/home/${user}/nixos/";
    };
  };
}
