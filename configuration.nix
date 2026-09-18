# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
#       ┌─────────────────────────┐
#       │     Configuration       │
#       └─────────────────────────┘
#  I am starting to understand! Wipe time!
{
  pkgs,
  inputs,
  config,
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

  services.udisks2.enable = true;

  #       ┌─────────────────────────┐
  #       │          Users          │
  #       └─────────────────────────┘
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # imports the hjemModule
  hjem.extraModules = [ inputs.hjem-impure.hjemModules.default ];
  # security.nix-secrets.secrets.password.neededForUsers = true;
  # users.users.teajhay = {
  #   home = "/home/teajhay";
  #   isNormalUser = true;
  #   hashedPasswordFile = config.security.nix-secrets.secrets.password.path;
  #   #initialPassword = "changeme";
  #   description = "Tea with a side of Jhay";
  #   extraGroups = [
  #     "wheel"
  #     "networkmanager"
  #   ]; # Enable ‘sudo’ for the user.
  #   shell = pkgs.zsh;
  # };
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
    # tuigreet  # Add to TUI-based host
    greetd
    gh
    fastfetch
    fzf
    lsd
    zsh-nix-shell
    prismlauncher
    starship
    age
    hyprcursor
    unstable.pear-desktop
    unstable.quickshell
    qt6.qtwayland
    libnotify
    slurp
    swappy
    grim
    wl-clipboard
    playerctl
    krita
    bitwarden-cli
    hyprpicker
    tesseract
    zbar
    imagemagick
    jq
    mpv
    translate-shell
    udiskie
    lynx
    loupe
    libimobiledevice
    ifuse

  ];

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
  #       ┌─────────────────────────┐
  #       │      Applications       │
  #       └─────────────────────────┘

  services.usbmuxd.enable = true;

  nixpkgs.overlays = [
    (final: prev: {
      prismlauncher = prev.prismlauncher.override {
        # 1. Provide all the Java versions you need for different Minecraft versions
        jdks = with prev; [
          temurin-bin-8 # For old Minecraft versions (1.7 - 1.12)
          temurin-bin-17 # For Minecraft 1.17 - 1.20
          temurin-bin-21 # For Minecraft 1.20.5+
          final.unstable.temurin-bin-26
        ];
      };
    })
  ];
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
