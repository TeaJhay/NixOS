{ lib, availableUsers, ... }:

{
  options.NixBeast.users.enabled = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    description = "List of user profiles to enable on this host";
    example = [ "squirrel" "guest" ];
  };

  options.NixBeast.users.available = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    readOnly = true;
    default = availableUsers;
    description = "All available user profiles (auto-discovered)";
  };
}
