{
  lib,
  self,
  inputs,
  ...
}: let
  assimilate = import ./assimilate.nix;
  inherit (lib.lists) remove;
  functions = assimilate ./. |> remove ./default.nix;
in
  lib.mergeAttrsList (map (path: (import path) {inherit lib inputs self;}) [./mkHosts.nix ./mkContainers.nix ./assimilate.nix])
