{lib, ...}: let
  assimilate = d:
    builtins.readDir d
    |> builtins.mapAttrs (name: type:
      if lib.hasPrefix "_" name
      then []
      else if type == "directory"
      then assimilate (d + "/${name}")
      else if lib.hasSuffix ".nix" name
      then [(d + "/${name}")]
      else [])
    |> builtins.attrValues
    |> builtins.concatLists;
in
  assimilate
