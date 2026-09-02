{ config, self, inputs, lib, ... }:
let
  inherit (inputs.findFiles) findFiles;
  inherit (lib) mkIf mkMerge listToAttrs map;

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


 
  # This is basically the template for what folders to search in, and if they exist use findFiles to list each file. These get merged in the users default.nix or equivalent
  getUserDotfiles = username: let # declares the function "getUserDotfiles" and parameter "username"
    dotfilesDir = usersDir + "/${username}/"; # sets the users dotfilees directory using the previously declared usersDir plus the structured path with their username as the parameter given by calling function.
  in
    if builtins.pathExists dotfilesDir # checks if the path exists
    then findFiles dotfilesDir # uses findFiles to return every file in the users dotfiles directory
    else {};




enabledUsers = config.NixBeast.users.enabled; # set enabledUsers tothe option for users enabled, imported after from ./options/default.nix, which gets set to the available users anyways. Possibly set this to use the declare users in config 
  invalidUsers = lib.filter (u: !(lib.elem u availableUsers)) enabledUsers; # filters invalid users by removing the enabled users from the list of availableUsers 
in {
  imports = [./options/default.nix]; # imports options used by enabledUsers
  config = mkMerge [ # mergs functions and results for use together
    {
      _module.args = {
        inherit getUserDotfiles availableUsers;
      };
    }
    (mkIf (enabledUsers != []) {
      assertions = [
        {
          assertion = lib.length invalidUsers == 0; # if there are invalid users, it fails and prints the users. Good for typo or clearing out removed users
          message =
            "Unknown user profiles: ${lib.toString invalidUsers}. "
            + "Available: ${lib.toString availableUsers}";
        }
      ];
      hjem.users = listToAttrs ( 
        map # uses list from the mkMerge to map to values, since this is for hjem this will map the following options for each hjerm user!
        (username: {
          name = username;
          value = {
            enable = true;
            user = username;
            directory = config.users.users.${username}.home;
            files = getUserDotfiles username;
          };
        })
        enabledUsers # the list of users it'll map hjem options for
      );

      hjem.clobberByDefault = true;
  })
  ];
}
#  - if you see this, you owe me Krone
