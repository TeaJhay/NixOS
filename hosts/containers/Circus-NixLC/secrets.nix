{
  self,
  inputs,
  hostName,
  ...
}: let
  host = "${self}/hosts/containers/${hostName}";
  hostSecrets = "/home/admin/nix/secrets";
in {
  imports = [inputs.nix-secrets.nixosModules.default];
  config = {
    security.nix-secrets = {
      enable = true;
      storage = "${host}/secrets";
      storagePath = hostSecrets;
      identityPaths = [
        "${hostSecrets}/admin.txt"
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
