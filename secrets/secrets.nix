{
  self,
  pkgs,
  ...
}:
{
  security.nix-secrets = {
    enable = true;
    extraPackages = with pkgs; [ age ];
    storage = "${self}/secrets"; # Relative path to your `secrets` (copied to /nix/store)
    storagePath = "/persistent/home/teajhay/nixos/secrets/"; # Absolute path to your `secrets` (copied to /nix/store)
    identityPaths = [
      "/persistent/home/teajhay/.ssh/keys.txt" # Path to your age private key
      "/persistent/home/teajhay/.ssh/id_ed25519" # You can also use SSH keys
    ];
    recipientAliases = {
      teajhay = "age1n0n7ml9drkk25uq7z0pz0avdnhdyxdwr470l8necmlrfyahudsaq274z9c"; # Your age recipient (public key)
      #ssh = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAJCp+y5me7/CLNNgVd8YYvyrWm1+7ZD7ztIS/cvJpIN nix-secrets"; # Or your SSH public key
    };

    # Add your secrets here...
    secrets = {
      password.recipients = [ "teajhay" ];
      githubSSH = {
        recipients = [ "teajhay" ];
        owner = "teajhay";
        mode = "0600";
      };
      githubGPG = {
        recipients = [ "teajhay" ];
        owner = "teajhay";
        mode = "0400";
      };
      #password.recipients = [ "teajhay" ];
      #password.recipients = [ "teajhay" ];
    };
  };
}
