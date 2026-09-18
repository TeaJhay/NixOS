{ ... }:
{
  #       ┌─────────────────────────┐
  #       │       Networking        │
  #       └─────────────────────────┘

  time.timeZone = "Australia/Brisbane"; # Set your time zone.

  networking = {
    hostName = "NixBeast";
    networkmanager = {
      enable = true;
      insertNameservers = [
        "10.0.1.101"
        "1.1.1.1"
      ];
      ensureProfiles.profiles = {
        "enp10s0" = {
          connection = {
            id = "enp10s0";
            type = "ethernet";
            interface-name = "enp10s0";
          };
          ipv4 = {
            method = "manual";
            addresses = "10.0.0.100/24";
            gateway = "10.0.0.1";
          };
          ethernet = {
            wake-on-lan = 1; # magic packet
          };
        };
      };
    };
    # Open ports in the firewall.
    firewall.allowedTCPPorts = [
      2049
      22
    ];
    firewall.allowedUDPPorts = [
      2049
      22
    ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;
  };

  programs.mtr.enable = true; # Some programs need SUID wrappers, can be configured further or are

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
      KbdInteractiveAuthentication = true;
    };
  };
}
