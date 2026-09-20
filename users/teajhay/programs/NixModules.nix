_: {
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
}
