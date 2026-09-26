{pkgs, ...}: {
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

  #       ┌─────────────────────────┐
  #       │         Packages        │
  #       └─────────────────────────┘

  environment.systemPackages = with pkgs; [
    #neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
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
    trash-cli
  ];
}
