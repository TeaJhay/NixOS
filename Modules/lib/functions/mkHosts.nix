{
  lib,
  self,
  inputs,
  ...
}: let
  hosts = builtins.filter (x: x != null) (
    lib.mapAttrsToList (name: value:
      if (value == "directory")
      then name
      else null) (
      builtins.readDir "${self}/hosts"
    )
  );
  nixosModules = import ../nixos;
in {
  mkHosts = builtins.listToAttrs (
    map (host: {
      name = host;
      value = lib.nixosSystem {
        specialArgs = {
          inherit inputs lib self;
        };

        modules = [
          {config.networking.hostName = host;}
          ("${self}/hosts" + "/${host}")
          nixosModules
        ];
      };
    })
    hosts
  );
}
