{ self, inputs, lib, ... }: # 
let
  inherit (inputs.findFiles) findFiles;

  usersDir = "${self}/users";  # Where users and their data is stored!
  userEntries = builtins.readDir usersDir; # Returns the contents of the users directory and if it's a file or directory
  # Could be combined, but then you can't use usersDir as a single path

  availableUsers =
    builtins.filter # Filters after settings the conditions, and then the list it needs to filter
    (u:
      userEntries.${u} # uses the contents of the usersDir
      == "directory" # Must be a directory
      && builtins.pathExists (usersDir + "/${u}/user.nix")) # A path with a certain file or folder in the usersDir must exist
    (builtins.attrNames userEntries); #List to filter from

  userDirPaths = [
    ".config"
    ".state"
    ".share"
  ]

  userFiles = username: let
    filesDir = usersDir + "/${username}/${userDirPaths}"
  in 
    if builtins.pathExists filesDir
      then findFiles filesDir
      else {};
in 
  config = mkMerge [
    {
      _module.args = {
        inherit getUserDotfiles availableUsers;
      };
    } 
    {
     hjem.users = listToAttrs (map (username: {
       name = username;
       value = {
         enable = true;
         user = username;
         directory = config.users.users.${username}.home;
         files = getUserDotfiles username;
       };
     }) availableUsers);
    }
  ];
  hjem.clobberByDefault = true; 

#  - if you see this, you owe me Krone
