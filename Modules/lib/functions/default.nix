{
  lib,
  self,
  inputs,
}: {
  assimilate = import ./assimilate.nix {inherit lib;};
  inherit ((import ./mkHosts.nix {inherit self inputs lib;})) mkHosts;
}
