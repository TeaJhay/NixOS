_: let
  user = baseNameOf ./.;
in {
  sys.impermanence = {
    enable = true;
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
      ".var/testtest"
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
        target = ".config/mimeapps.list";
        method = "symlink";
      }
      {
        target = ".config/nvim/lua/matugen.lua";
        method = "symlink";
      }
      {
        target = ".config/nvim/lua/matugen-template.lua";
        method = "symlink";
      }
      {
        target = ".config/kitty/themes/noctalia.conf";
        method = "symlink";
      }
      {
        target = ".zsh_history";
        method = "symlink";
      }
      ".config/jjui/config.toml"
    ];
  };
}
