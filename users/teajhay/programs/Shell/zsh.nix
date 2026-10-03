{pkgs, ...}: {
  # Enable zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ls = "eza --icons --group-directories-first";
      lsa = "eza --icons --group-directories-first -a";
      ll = "eza --icons --group-directories-first -alh";
      lc = "eza --group-directories-first --icons -alh --loc";
      lcd = "eza --group-directories-first --icons -alh --code";
      cat = "bat";
      cd = "z";
      cdi = "zi";
      clean = ''clear && printf "\033[3J"'';
      nixsize = "nix path-info -Sh .#nixosConfigurations.NixBeast.config.system.build.toplevel";
      testupdate = "nh os test -H NixBeast";
      update = "nh os switch -H NixBeast";
      upgrade = "nh os switch -H NixBeast --update --ask";
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
      "GLOB_DOTS"
    ];
    shellInit = "zsh-newuser-install() { :; }";
    interactiveShellInit = ''
      unalias ll 2>/dev/null
      unalias ls 2>/dev/null
      ZSH_DISABLE_COMPFIX="true"

      fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc

      # Set-up FZF key bindings (CTRL R for fuzzy history finder)
      source <(fzf --zsh)

      eval "$(zoxide init zsh)"
      eval "$(starship init zsh)"
    '';
  };
  environment.systemPackages = with pkgs; [
    gh
    fastfetch
    fzf
    zsh-nix-shell
    ripgrep
    tealdeer
    fd
    unzip
    nodejs
    jujutsu
    jjui
    trash-cli
    unstable.eza
    bat
    zoxide
  ];
}
