{
  lib,
  self,
  inputs,
  ...
}: let
  assimilate = import ./assimilate.nix;
  inherit (lib.lists) remove;
in
  lib.mergeAttrsList (map (path: (import path) {inherit lib inputs self;}) [./mkHosts.nix ./assimilate.nix])
