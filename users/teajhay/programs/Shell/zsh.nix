{pkgs, ...}: {
  # Enable zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "eza --icons --group-driectories-first";
      ll = "eza --icons --group-driectories-first -alh";
      cat = "bat";
      grep = "rg";
      find = "fd";
      cd = "z";
      clean = ''clear && printf "\033[3J"'';
      nixsize = "nix path-info -Sh .#nixosConfigurations.NixBeast.config.system.build.toplevel";
      testupdate = "nh os test -H NixBeast";
      update = "nh os switch -H NixBeast";
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
  environment.systemPackages = with pkgs; [
    gh
    fastfetch
    fzf
    lsd
    zsh-nix-shell
    ripgrep
    tealdeer
    fd
    unzip
    nodejs
    jujutsu
    jjui
    trash-cli
    eza
    bat
  ];
}
