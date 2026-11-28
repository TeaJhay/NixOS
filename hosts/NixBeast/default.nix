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
    services = {
      modprobed.enable = true;
      openLinkHub.enable = true;
      ssh.enable = true;
      udisk2.enable = true;
    };
    # TODO: change options from ``category.xyz.enable`` to ``category.xyz = true/false`` or ``category = []``
    cli = {
      p7z.enable = true;
      bat.enable = true;
      btop.enable = true;
      eza.enable = true;
      fd.enable = true;
      fzf.enable = true;
      kitty.enable = true;
      ripgrep.enable = true;
      starship.enable = true;
      tealdeer.enable = true;
      trash.enable = true;
      zoxide.enable = true;
      zsh.enable = true;
    };
    apps = {
      ios.enable = true;
      music.enable = true;
      photo.enable = true;
      onlyOffice.enable = true;
      stremio.enable = true;
      thunderbird.enable = true;
      zenBrowser.enable = true;
    };
    gaming = {
      general.enable = true;
      prismLauncher.enable = true;
    };
  };
}
