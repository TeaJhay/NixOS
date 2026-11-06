{lib, ...}: let
  inherit (lib) mkOption;
  inherit (lib.types) str;
in {
  options.host.system = {
    services = {
      ipv4 = mkOption {
        type = str;
        default = "";
        description = "ipv4 address used to access this service";
      };
      ipv6 = mkOption {
        type = str;
        default = "";
        description = "ipv6 address used to access this service";
      };
      port = mkOption {
        type = str;
        default = "";
        description = "Port used to access this service";
      };
      baseDomain = mkOption {
        type = str;
        default = "";
        description = "Base domain to be used with this service";
      };
    };
  };
}
