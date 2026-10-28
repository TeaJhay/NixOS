{
  lib,
  config,
  options,
  ...
}: let
  inherit (lib) mkOption mkMerge mkIf filter stringToCharacters;
  inherit (lib.types) listOf submodule addCheck nullOr str;
  nospace = str: filter (c: c == " ") (stringToCharacters str) == [];
  timezone =
    nullOr (addCheck str nospace)
    // {
      description = "null or string without spaces";
    };
  cfg = config.host.system;
  own = ["timezone" "dns" "resolved"];

  networkingModule = removeAttrs options.networking ["_module"];
in {
  options.host.system.networking = mkOption {
    default = {};
    description = "Upstream `networking.*` options plus host-specific extras.";
    type = submodule {
      options =
        networkingModule
        // {
          useNetworkd = networkingModule.useNetworkd // {default = true;};
          nftables.enable = networkingModule.nftables.enable // {default = true;};
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
            description = ''
              Extra nameservers, appended to `networking.nameservers`,
              which systemd-resolved reads for its `DNS` setting.
            '';
          };

          resolved = mkOption {
            type = options.services.resolved.settings.Resolve.type;
            default = {};
            description = "Passthrough for `services.resolved.settings.Resolve`.";
          };
        };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      time.timeZone = cfg.networking.timezone;
      services.resolved = {
        enable = true;
        settings.Resolve = cfg.networking.resolved;
      };
      networking.domain = cfg.networking.dns;
    }
    {
      networking = removeAttrs cfg.networking own;
    }
    {
      networking.nameservers = cfg.networking.dns;
    }
  ]);
}
