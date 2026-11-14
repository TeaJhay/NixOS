{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) attrsOf submodule str;
in {
  options.homelab = mkOption {
    description = "Users on this host";
    type = attrsOf (submodule {
      options = {
        enable = mkEnableOption "enable caddy reverse-proxy and webserver, in addition to Caddy/ui";
        url = mkOption {
          type = str;
          default = "${config.subDomain}.${config.baseDomain}";
          defaultText = lib.literalExpression ''"''${config.subDomain}.''${config.baseDomain}"'';
          description = "url this service is served on";
        };
        baseDomain = mkOption {
          type = str;
          default = "";
          description = "basedomain to be used with this service";
        };
        subDomain = mkOption {
          type = str;
          default = "";
          description = "subdomain to be used with this service";
        };
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
      };
    });
  };
}
