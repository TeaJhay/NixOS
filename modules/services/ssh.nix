{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkDefault mkIf mkMerge;
  cfg = config.sys.services.ssh;
in {
  config = mkMerge [
    {
      sys.services.ssh.enable = mkDefault false;
    }
    (mkIf cfg.enable {
      services = {
        openssh = {
          enable = true;
          openFirewall = true;
          settings = {
            PasswordAuthentication = true;
            PermitRootLogin = "yes";
            KbdInteractiveAuthentication = true;
          };
        };
      };
      environment.systemPackages = with pkgs; [
        sshfs
        lazyssh
      ];
    })
  ];
}
