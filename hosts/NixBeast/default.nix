_: {
  host.system = {
    enable = true;
    unfreeSoftware = true;
    users.teajhay = {
      role = "admin";
    };
    hardware = {
      platform = "x86_64-linux";
      modules = [
        "cpu/amd"
        "gpu/amd"
        "peripherals/logitech"
        "audio"
        "bluetooth"
        "ssd"
        "wifi"
      ];
    };
    networking = {
      timezone = "Australia/Brisbane";
      tcpcrypt.enable = true;
      firewall = {
        enable = true;
        allowedTCPPorts = [];
        allowedUDPPorts = [];
      };
      defaultGateway = {
        address = "10.0.0.1";
        interface = "enp10s0";
        source = "10.0.0.100";
      };
      dns = ["10.0.1.101"];
      resolved = {
        DNSSEC = true;
        Domains = ["doesntcompute.site"];
      };
    };
  };
}
