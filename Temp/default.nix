{
  self,
  lib,
  ...
}: let
  inherit (self.lib) assimilate;
  inherit (lib.lists) remove;
in {
  imports = assimilate ./. |> remove ./default.nix;
  environment.etc."machine-id".text = "02593cf2c06c4f61836f38cc685434a5";
}
