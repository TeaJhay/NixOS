{lib, ...}:
lib.extend (
  final: _prev: {
    assimilate = d:
      builtins.readDir d
      |> builtins.mapAttrs (name: type:
        if (lib.hasPrefix "_" name)
        then []
        else if type == "directory"
        then final.assimilate (d + "/${name}")
        else if (lib.hasSuffix ".nix" name)
        then [(d + "/${name}")]
        else [])
      |> builtins.attrValues
      |> builtins.concatLists;
  }
)
