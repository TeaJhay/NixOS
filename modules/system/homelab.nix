{lib, ...}: let
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) attrsOf nullOr port str submodule;
in {
  options.homelab = mkOption {
    description = "Users on this host";
    type = attrsOf (submodule ({config, ...}: {
      options = {
        enable = mkEnableOption "this service and it's related configuration, including modules and oci-containers";
        baseDomain = mkOption {
          type = str;
          description = "Base domain used with this service";
        };

        subDomain = mkOption {
          type = str;
          description = "Subdomain used with this service";
        };

        url = mkOption {
          type = str;
          default = "${config.subDomain}.${config.baseDomain}";
          defaultText = lib.literalExpression ''"''${config.subDomain}.''${config.baseDomain}"'';
          description = "URL this service is served on. Defaults to {subDomain}.{baseDomain}";
        };

        ipv4 = mkOption {
          type = nullOr str;
          default = null;
          description = "IPv4 address used to access this service";
        };

        ipv6 = mkOption {
          type = nullOr str;
          default = null;
          description = "IPv6 address used to access this service";
        };

        port = mkOption {
          type = port;
          description = "Port used to access this service";
        };
      };
    }));
  };
}
