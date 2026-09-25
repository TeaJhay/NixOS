_: {
  # Enable zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      edit = "sudo -E nvf";
      testupdate = "sudo nixos-rebuild test --show-trace --flake #NixBeast";
      update = ''sudo NIXOS_LABEL="$(jj log -r @ -n 1 --no-graph -T 'commit_id.short(7) ++ "-" ++ description.first_line()' | tr ' ' '_')" nixos-rebuild switch --show-trace --flake #NixBeast'';
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
