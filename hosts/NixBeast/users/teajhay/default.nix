{pkgs, ...}: let
  user = baseNameOf ./.;
in {
  users.users."${user}" = {
    shell = pkgs.zsh;
  };

  environment.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "kitty";
    FILES = "yazi";
    STARSHIP_CONFIG = "/home/teajhay/.config/starship/starship.toml";
    NIXOS_CONFIG = "/persistent/home/teajhay/nixos/";
  };
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
}
