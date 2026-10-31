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
        allowedTCPPorts = [
          2049
          22
          443
          80
        ];
        allowedUDPPorts = [
          2049
          22
          443
          80
        ];
      };
      interfaces.enp10s0.wakeOnLan.enable = true;
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
