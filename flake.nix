{
  description = "My Slice of Hell";

  outputs = {self} @ args: let
    # set library to lib folder
    library = "${self}/Modules/lib";
    # Set inputs to use tacks
    inputs = (import ./.tack) {
      overrides = args.tackOverrides or {};
    };
    # Set lib to in-house expressions. Functions and expressions
    lib = inputs.nixpkgs.lib.extend (final: _prev:
      import "${library}/functions" {
        inherit self inputs;
        lib = final;
      });
  in {
    nixosConfigurations = lib.mkHosts;
  };
}
