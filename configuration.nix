# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
#       ┌─────────────────────────┐
#       │     Configuration       │
# └─────────────────────────┘
#  I am starting to understand! Wipe time!
{
  pkgs,
  inputs,
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

  services.usbmuxd.enable = true;
  services.udisks2.enable = true;
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
    hyprcursor
    unstable.pear-desktop
    unstable.quickshell
    qt6.qtwayland
    playerctl
    krita
    bitwarden-cli
    udiskie
    lynx
    loupe
    libimobiledevice
    ifuse
  ];

  #       ┌─────────────────────────┐
  #       │      Applications       │
  #       └─────────────────────────┘


  programs.gamemode.enable = true;
  programs.steam.enable = true;

  programs.git = {
    enable = true;
    config = {
      user = {
        name = "Teajhay";
      };
    };
  };
  programs.thunderbird.enable = true;
  #programs.starship = {
  #    enable = true;
  #    settings = lib.mkMerge [
  #      (builtins.fromTOML
  #        (builtins.readFile "/home/teajhay/.config/starship/starship.toml"
  #      ))
  #    ];
  #  };
  services.flatpak.enable = true;
  # Enable zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      gitbeam = "git commit -a -m 'edits' && git push";
      edit = "sudo -E nvim";
      update-pers = "sudo nixos-rebuild switch --show-trace --flake /persistent/home/NixOS#nixos";
      update = "sudo nixos-rebuild switch --show-trace --flake #NixBeast";
      nmtui = "env NEWT_COLORS='root=white,black border=black,lightgray window=lightgray,lightgray title=black,lightgray button=black,cyan' nmtui";
    };

    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
      ];
    };

    histSize = 10000;
    histFile = "$HOME/.zsh_history";
    setOptions = [
      "HIST_IGNORE_ALL_DUPS"
    ];
  };

}
