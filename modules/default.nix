{
  self,
  lib,
  ...
}: let
  inherit (self.lib) assimilate;
  inherit (lib.lists) remove;
in {
  # Return a single module that automatically loads all the individual files
  imports = assimilate ./. |> remove ./default.nix;
}
