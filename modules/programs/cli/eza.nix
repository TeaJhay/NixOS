{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.sys.cli.eza;
in {
  options.sys.cli.eza.enable = mkEnableOption "eza: ''ls'' replacement module";
  config = mkIf cfg.enable {
    environment = {
      systemPackages = [pkgs.eza];
      shellAliases = {
        ls = "eza --icons --group-directories-first";
        lsa = "eza --icons --group-directories-first -a";
        ll = "eza --icons --group-directories-first -alh";
        lc = "eza --group-directories-first --icons -alh --loc";
        lcd = "eza --group-directories-first --icons -a --code";
        lstree = "eza --tree";
      };
    };
  };
}
