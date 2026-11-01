{
  outputs = {self} @ args: let
    inputs = (import ./.tack) {
      overrides = args.tackOverrides or {};
    };
    lib = inputs.nixpkgs.lib;
    inherit (self.lib) mkHosts;
    lib' = import ./lib {inherit lib inputs self;};
  in {
    lib = lib';
    nixosConfigurations = mkHosts;
  };
}
