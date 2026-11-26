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
        "${hostName}/lfsJwtSecret" = {
          recipients = ["admin"];
          owner = "admin";
        };
        "${hostName}/jwtSecret" = {
          recipients = ["admin"];
          owner = "admin";
        };
        "${hostName}/InternalToken" = {
          recipients = ["admin"];
          owner = "admin";
        };
        "${hostName}/smtpAddr" = {
          recipients = ["admin"];
          owner = "admin";
        };
        "${hostName}/smtpPort" = {
          recipients = ["admin"];
          owner = "admin";
        };
        "${hostName}/user" = {
          recipients = ["admin"];
          owner = "admin";
        };
        "${hostName}/passwd" = {
          recipients = ["admin"];
          owner = "admin";
        };
      };
    };
    security.rtkit.enable = true;
  };
}
