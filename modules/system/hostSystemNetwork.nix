{
  lib,
  config,
  options,
  ...
}: let
  inherit (lib) mkOption mkMerge mkIf mkDefault filter stringToCharacters;
  inherit (lib.types) listOf submodule addCheck nullOr str attrsOf anything;
  nospace = s: filter (c: c == " ") (stringToCharacters s) == [];
  timezone =
    nullOr (addCheck str nospace)
    // {description = "null or string without spaces";};
  cfg = config.host.system;
  own = ["timezone" "dns" "resolved"];
in {
  options.host.system.networking = mkOption {
    default = {};
    description = "Upstream `networking.*` settings plus host-specific extras.";
    type = submodule {
      freeformType = attrsOf anything;
      options = {
        timezone = mkOption {
          type = timezone;
          default = "Australia/Brisbane";
          example = "Australia/Sydney";
          description = "The time zone used when displaying times and dates.";
        };
        dns = mkOption {
          type = listOf str;
          default = ["1.1.1.1"];
          example = ["1.1.1.1" "10.0.1.101"];
          description = "Extra nameservers, appended to `networking.nameservers`.";
        };
        resolved = mkOption {
          type = options.services.resolved.settings.Resolve.type;
          default = {};
          description = "Passthrough for `services.resolved.settings.Resolve`.";
        };
      };
    };
  };

  config = mkIf (cfg.enable && !cfg.virtual.enable) (mkMerge [
    {
      time.timeZone = cfg.networking.timezone;
      services.resolved = {
        enable = true;
        settings.Resolve = cfg.networking.resolved;
      };
      networking = {
        useNetworkd = mkDefault true;
        nftables.enable = mkDefault true;
        nameservers = cfg.networking.dns;
      };
    }
    {networking = removeAttrs cfg.networking own;}
  ]);
}
