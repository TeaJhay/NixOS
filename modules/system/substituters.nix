_: let
  substituters = [
    # CORE
    {
      url = "https://cache.nixos.org";
      priority = 10;
      public_key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
    }
    {
      url = "https://nix-community.cachix.org";
      priority = 20;
      public_key = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
    }
    # MODULES
    {
      # hyprland
      url = "https://hyprland.cachix.org";
      priority = 30;
      public_key = "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=";
    }
    {
      # ncro
      url = "https://cache.manic.systems";
      priority = 30;
      public_key = "cache.manic.systems-1:s6OZanN8Us8vRi0jVivP3qlMn0cYHBjBALKrNe5nH8s=";
    }
    # circus
    {
      url = "https://cache.doesntcompute.site/nix-cache";
      priority = 60;
      public_key = "cache.doesntcompute.site-1:cTv/ePA602QGzUci4rMdYGkuS4LA0NzEjoWnaHAwvAg=";
    }
  ];

  # entries without a key are left out of the generated settings
  usable = builtins.filter (s: s.public_key != "") substituters;
in {
  # makes ``substituters.substituters`` available as an argument in any other module
  _module.args.substituters = substituters;

  nix.settings = {
    substituters = map (s: "${s.url}?priority=${toString s.priority}") usable;
    trusted-public-keys = map (s: s.public_key) usable;
  };
}
