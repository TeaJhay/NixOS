{
  lib,
  pkgs,
  config,
  options,
  modulesPath,
  ...
}: let
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) submodule;
  inherit (lib) mkDefault;
  cfg = config.sys;
  proxmoxModule = removeAttrs (options.proxmoxLXC or {}) ["_module"];
  ssh-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZ9m9RlLXNMoakl6Df7Rrfl+0ChqeeJf2afrX+d94wy openpgp:0x973131DA";
in {
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
  ];
  options.sys.virtual = {
    enable = mkEnableOption ''
      is a virtual host. This option can cause an unbootable system.
    '';

    proxmox = mkOption {
      default = {};
      description = "proxmoxLXC options";
      type = submodule {
        options = proxmoxModule;
      };
    };
  };
  config = mkMerge [
    {
      proxmoxLXC.enable = mkDefault false;
    }
    (mkIf (cfg.role == "lxc-virt" && cfg.virtual.enable)
      {
        nix = {
          settings = {
            experimental-features = ["nix-command" "flakes" "pipe-operators"];
            auto-optimise-store = true;
            trusted-users = ["root" "@wheel"];
          };
        };

        proxmoxLXC = cfg.virtual.proxmox;
        services.resolved.enable = false;
        networking.resolvconf.enable = false;
        # Suppress systemd units that fail inside unprivileged LXC environments
        systemd.suppressedSystemUnits = [
          "dev-mqueue.mount"
          "sys-fs-fuse-connections.mount"
        ];
        system.stateVersion = config.system.nixos.release; # Match your targets

        environment.sessionVariables = {
          EDITOR = "micro";
        };
        # Pre-install essential tooling
        environment.systemPackages = with pkgs; [
          git
          micro
          jujutsu
          curl
          btop
          iproute2 # For 'ip a' and 'ip route'
          dnsutils # For `dig` and `nslookup` (crucial for diagnosing bad DNS)
          microfetch
          kitty.terminfo
          mosh
          nnn
          iptraf-ng
          pv
          s-tui
          carapace
          fishPlugins.z
          jjui
          dua
        ];
        # User Settings
        security.sudo.wheelNeedsPassword = false;
        users.users = {
          admin = {
            isNormalUser = true;
            extraGroups = ["wheel" "podman"]; # Grants sudo access
            openssh.authorizedKeys.keys = [ssh-key];
            shell = pkgs.fish;
            linger = true;
            subUidRanges = [
              {
                startUid = 10000;
                count = 50000;
              }
            ];
            subGidRanges = [
              {
                startGid = 10000;
                count = 50000;
              }
            ];
          };
          root.openssh.authorizedKeys.keys = [ssh-key];
        };
        programs = {
          fish = {
            enable = true;
            shellInit = ''
              set -p fish_function_path ${pkgs.fishPlugins.tide}/share/fish/vendor_functions.d
            '';
          };
          nh = {
            enable = true;
            clean.enable = true;
            clean.extraArgs = "--keep-since 5d --keep 20";
            flake = "/home/admin/nix"; # sets NH_OS_FLAKE variable for you
          };
        };
        # SSH Settings
        services.openssh = {
          enable = true;
          settings = {
            PasswordAuthentication = true;
            KbdInteractiveAuthentication = false;
            PermitRootLogin = "yes";
          };
        };
      })
  ];
}
