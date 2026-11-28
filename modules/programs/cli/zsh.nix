{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.sys.cli.zsh;
in {
  options.sys.cli.zsh.enable = mkEnableOption "zsh: ''bash'' replacement module";
  config = mkIf cfg.enable {
    programs.zsh = {
      inherit (cfg) enable;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        clean = ''clear && printf "\033[3J"'';
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
        ZSH_DISABLE_COMPFIX="true"

        fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc

        eval "$(zoxide init zsh)"
        eval "$(starship init zsh)"
        eval "$(direnv hook zsh)"
      '';
    };
    environment.systemPackages = with pkgs; [
      fastfetch
      zsh-nix-shell
      nodejs
      trash-cli
    ];
  };
}
