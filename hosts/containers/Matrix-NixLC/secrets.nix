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
        password.recipients = ["admin"];
        "${hostName}/token_file" = {
          recipients = ["admin"];
          owner = "continuwuity";
          group = "continuwuity";
          mode = "0400";
        };
      };
    };
    security.rtkit.enable = true;
  };
}
