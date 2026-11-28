{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.sys.services.ssh;
in {
  #options.sys.services.ssh.enable = mkEnableOption "openssh: Secure shell service, additionally adds lazyssh and sshfs";
  config = mkIf cfg.enable {
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
  };
}
