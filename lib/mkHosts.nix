{
  lib,
  inputs,
  self,
  ...
}: let
  inherit (self.lib) assimilate;
  hosts = builtins.filter (x: x != null) (
    lib.mapAttrsToList (name: value:
      if (value == "directory")
      then name
      else null) (
      builtins.readDir "${self}/hosts"
    )
  );
in {
  mkHosts = builtins.listToAttrs (
    map (host: {
      name = host;
      value = lib.nixosSystem {
        specialArgs = {
          inherit inputs self;
        };

        modules =
          [
            {config.networking.hostName = host;}
            (self + "/modules")
          ]
          ++ (
            assimilate (self + "/hosts/${host}")
            |> lib.filter (
              p: builtins.match ".*/hosts/NixBeast/users/[^/]+/xdg(/.*)?" (toString p) == null
            )
          );
      };
    })
    hosts
  );
}
