_: let
  baseDomain = "doesntcompute.site";
in {
  homelab = {
    circus = {
      ipv4 = "10.0.1.111";
      port = 3000;
      subDomain = "cache";
      inherit baseDomain;
    };
    caddy = {
      ipv4 = "10.0.1.10";
      port = 9877;
      subDomain = "caddy";
      inherit baseDomain;
    };
    technitium = {
      ipv4 = "10.0.1.101";
      port = 80;
      subDomain = "dns";
      inherit baseDomain;
    };
    discord-media = {
      ipv4 = "10.0.1.109";
      port = 29334;
      subDomain = "discord-media";
      inherit baseDomain;
    };
    baseDomain = {
      ipv4 = "10.0.1.109";
      port = 8008;
      subDomain = "";
      inherit baseDomain;
    };
    tandoor = {
      ipv4 = "10.0.1.119";
      port = 80;
      subDomain = "food";
      inherit baseDomain;
    };
    forgejo = {
      ipv4 = "10.0.1.181";
      port = 3000;
      subDomain = "git";
      inherit baseDomain;
    };
    glances = {
      ipv4 = "10.0.1.1";
      port = 61208;
      subDomain = "glances";
      inherit baseDomain;
    };
    homeAssistant = {
      ipv4 = "10.0.1.206";
      port = 8123;
      subDomain = "homeassistant";
      inherit baseDomain;
    };
    immich = {
      ipv4 = "10.0.1.120";
      port = 2283;
      subDomain = "immich";
      inherit baseDomain;
    };
    continuwuity = {
      ipv4 = "10.0.1.109";
      port = 8008;
      subDomain = "matrix";
      inherit baseDomain;
    };
    mautrix-discord = {
      ipv4 = "10.0.1.109";
      port = 29334;
      subDomain = "mautrix-discord";
      inherit baseDomain;
    };
    TrueNAS = {
      ipv4 = "10.0.1.200";
      port = 80;
      subDomain = "nas";
      inherit baseDomain;
    };
    proxmox = {
      ipv4 = "10.0.1.1";
      port = 8006;
      subDomain = "pve";
      inherit baseDomain;
    };
    iVentoy = {
      ipv4 = "10.0.1.107";
      port = 26000;
      subDomain = "pxe";
      inherit baseDomain;
    };
    firefoxSync = {
      ipv4 = "10.0.1.112";
      port = 5000;
      subDomain = "sync";
      inherit baseDomain;
    };
    wg-dash = {
      ipv4 = "10.0.1.105";
      port = 19986;
      subDomain = "vpn";
      inherit baseDomain;
    };
    vaultwarden = {
      ipv4 = "10.0.1.100";
      port = 8000;
      subDomain = "vw";
      inherit baseDomain;
    };
    trilium = {
      ipv4 = "10.0.1.106";
      port = 8080;
      subDomain = "wiki";
      inherit baseDomain;
    };
  };
}
