# Created by this jetpackmaniac: https://github.com/Michael-C-Buckley/findFiles.nix
#
# The expression requires `lib`, which comes from packages
# Either it can be passed explicitly or it will use the angle brackets
#  to detect it on the system and use whatever local version is available
# This would be sufficient since it is just using a few filesystem expressions
{
  lib ? import <nixpkgs>.lib { },
  ...
}:
# The file is the expression, which has one argument, the target directory
directory:
let
  # Inherits help keep declutter the rest of the expression
  # as long namespaces are not used or repeated
  inherit (builtins) toString pathExists unsafeDiscardStringContext;
  inherit (lib.attrsets) listToAttrs;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.lists) map;
  inherit (lib.strings) removePrefix;
  directoryPrefix = (toString directory) + "/";
in
if pathExists directory then
  # The meat of the expression
  listToAttrs (
    map (filepath: {
      name = unsafeDiscardStringContext (removePrefix directoryPrefix (toString filepath));
      value.source = filepath;
    }) (listFilesRecursive directory)
  )
else
  # A non-existant path will cause an evaluation warning but not error
  # The expression will return an empty attribute set
  builtins.trace "findFiles: directory does not exist: ${toString directory}" { }
