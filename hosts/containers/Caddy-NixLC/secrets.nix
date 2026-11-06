{
  self,
  config,
  inputs,
  ...
}: let
  hostName = config.networking.hostName;
  host = "${self}/hosts/containers/${hostName}";
in {
  imports = [inputs.nix-secrets.nixosModules.default];
  config = {
    security.nix-secrets = {
      enable = true;
      storage = "${host}/secrets";
      storagePath = "${self}/secrets";
      identityPaths = [
        "${self}/secrets/admin.txt"
      ];
      recipientAliases = {
        admin = "age1ffhwld5y09rpyuuzwks0y272wltpgvsafxaud3n2n05gyz73cyqqyaqglg";
      };
      secrets = {
        password.recipients = ["admin"];
        "${hostName}/circus_api" = {
          recipients = ["admin"];
          owner = "admin";
        };
        "${hostName}/circus_signing" = {
          recipients = ["admin"];
          owner = "admin";
        };
        "${hostName}/circus_password" = {
          recipients = ["admin"];
          owner = "admin";
        };
      };
    };
    security.rtkit.enable = true;
  };
}
