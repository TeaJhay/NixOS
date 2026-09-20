# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
#       ┌─────────────────────────┐
#       │     Configuration       │
# └─────────────────────────┘
#  I am starting to understand! Wipe time!
{
  pkgs,
  ...
}:

{
  imports = [
    ./hosts/NixBeast # import hardware-configuration (partitions) and other configs.
    ./Modules/Filesystem
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  #       ┌─────────────────────────┐
  #       │          Users          │
  #       └─────────────────────────┘
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  #       ┌─────────────────────────┐
  #       │         Packages        │
  #       └─────────────────────────┘

  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    nixfmt
    alejandra
    nil
    ripgrep
    fd
    unzip
    nodejs
    gcc
    nixd
    python3
    gnumake
    greetd
    gh
    fastfetch
    fzf
    lsd
    zsh-nix-shell
    starship
    age
    unstable.pear-desktop
    unstable.quickshell
    qt6.qtwayland
    krita
    bitwarden-cli
    udiskie
    lynx
    loupe
    jujutsu
    jjui
  ];

  #       ┌─────────────────────────┐
  #       │      Applications       │
  #       └─────────────────────────┘

  # Enable zsh
}
