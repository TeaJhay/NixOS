{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  user = "<fill here>";
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
      home = "/home/'${user}'";
      isNormalUser = true;
      #hashedPasswordFile = config.security.nix-secrets.secrets.password.path; # If multiple users, call the secret password-"${user}"
      initialPassword = "changeme";
      description = "<Fill>";
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
        # Add prefered nixpkgs fonts here
        ibm-plex
        nerd-fonts.iosevka
      ];

      fontconfig = {
        defaultFonts = {
          # Set default fonts here
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
      # This is so nix profiles are persisted and useable, e.g. when using NVF as a profile over config.
      "L+ /home/'${user}'/.nix-profile - - - - .local/state/nix/profiles/profile"
    ];
    #       ┌─────────────────────────┐
    #       │        Env Vars         │
    #       └─────────────────────────┘
    environment.sessionVariables = {
      # Set default env vars for use in apps or commands.
      EDITOR = "nvim";
      STARSHIP_CONFIG = "/home/'${user}'/.config/starship/starship.toml";
      NIXOS_CONFIG = "/persistent/home/'${user}'/nixos/";
    };
  };
}
