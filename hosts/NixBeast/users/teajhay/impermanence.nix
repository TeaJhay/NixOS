{
  inputs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  user = baseNameOf ./.;
  cfg = config.host.system.impermanence;
in {
  imports = [inputs.nixos-core.nixosModules.default];
  config = mkIf cfg.enable {
    sys.impermanence = {
      inherit user;
      directories = [
        ".config/jj/repos"
        ".config/zen"
        ".config/YouTube Music"
        ".config/vesktop"
        ".config/gh"
        ".java"
        ".local/share/direnv"
        ".local/share/PrismLauncher"
        ".local/share/Steam"
        ".local/share/applications"
        ".local/share/krita"
        ".local/share/flatpak"
        ".local/share/icons"
        ".local/share/keyrings"
        ".local/share/nvim"
        ".local/share/stremio"
        ".local/share/zoxide"
        ".local/state/wireplumber"
        ".local/state/noctalia"
        ".local/state/modprobed-db"
        ".local/state/nix/profiles"
        ".ssh"
        ".config/yazi/flavors/noctalia.yazi"
        ".gnupg"
        "Dev/vfs"
        ".thunderbird"
        ".steam"
        ".var/app"
        ".config/millennium"
        ".local/share/millennium"
        ".local/share/heroic"
        ".config/heroic"
        ".cache/tealdeer"
        ".cache/nix"
      ];
      files = [
        ".gitconfig"
        {
          file = ".config/mimeapps.list";
          method = "symlink";
        }
        {
          file = ".config/nvim/lua/matugen.lua";
          method = "symlink";
        }

        {
          file = ".config/nvim/lua/matugen-template.lua";
          method = "symlink";
        }
        {
          file = ".config/kitty/themes/noctalia.conf";
          method = "symlink";
        }
        {
          file = ".zsh_history";
          method = "symlink";
        }
        ".config/jjui/config.toml"
      ];
    };
  };
}
