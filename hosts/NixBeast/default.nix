_: {
  sys = {
    enable = true;
    role = "desktop";
    unfreeSoftware = true;
    platform = "x86_64-linux";
    users.teajhay = {
      role = "admin";
    };
    hardware = {
      machine-id = "02593cf2c06c4f61836f38cc685434a5";
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
      tcpcrypt.enable = false;
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
