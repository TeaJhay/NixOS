_: {
  host.system = {
    enable = true;
    role = "lxc-virt";
    unfreeSoftware = true;
    platform = "x86_64-linux";
    virtual = {
      enable = true;
      proxmox.enable = true;
    };
    services.caddy = {
      enable = true;
      ipv4 = "10.0.1.10";
      port = "9877";
      subDomain = "caddy";
      baseDomain = "doesntcompute.site";
    };
  };
}
