{ self, config, ... }:
{
  security.nix-secrets = {
    enable = true;
    storage = "${self}/secrets"; # Relative path to your `secrets` (copied to /nix/store)
    identityPaths = [   
      "/home/teajhay/.secrets/keys.txt" # Path to your age private key
      "/home/teajhay/.secrets/id_ed25519" # You can also use SSH keys
    ]; 
    recipientAliases = {
      teajhay = "age1vujfnw9h7nypxcj02078266p27t7lrlvz97tq7vzmmp9nkgjqceqlc8mrd"; # Your age recipient (public key)
      ssh = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICzGkL28+ce29nwATfti4KggQojZQRDbmWGmNqskOxKG"; # Or your SSH public key
    };

    # Add your secrets here...
    secrets = {
      password.recipients = [ "teajhay" ];
      signingKey.recipients = [ "ssh" ];
      addres.recipients = [ "teajhay" ];
    };
  };
}
