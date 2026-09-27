_: {
  # Enable zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      clean = ''clear && printf "\033[3J"'';
      nixsize = "nix path-info -Sh .#nixosConfigurations.NixBeast.config.system.build.toplevel";
      edit = "sudo -E nvf";
      testupdate = "sudo nixos-rebuild test --show-trace --flake #NixBeast";
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
