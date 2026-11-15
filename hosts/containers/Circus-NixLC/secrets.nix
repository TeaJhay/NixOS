{
  inputs,
  hostName,
  ...
}: let
  hostSecrets = "/home/admin/nix/secrets";
in {
  imports = [inputs.nix-secrets.nixosModules.default];
  config = {
    security.nix-secrets = {
      enable = true;
      storage = inputs.secrets;
      storagePath = hostSecrets;
      identityPaths = [
        "${hostSecrets}/admin.txt"
      ];
      recipientAliases = {
        admin = "age1ffhwld5y09rpyuuzwks0y272wltpgvsafxaud3n2n05gyz73cyqqyaqglg";
      };
      secrets = {
        password = {
          recipients = ["admin"];
          neededForUsers = true;
        };
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
        "${hostName}/smtp_password" = {
          recipients = ["admin"];
          owner = "admin";
        };
        "${hostName}/circus_oidc_secret" = {
          recipients = ["admin"];
          owner = "admin";
        };
      };
    };
    security.rtkit.enable = true;
  };
}
