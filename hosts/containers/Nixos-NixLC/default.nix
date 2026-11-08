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
    services = {
      ipv4 = "10.0.1.10";
      port = "";
      baseDomain = "doesntcompute.site";
    };
  };
}
