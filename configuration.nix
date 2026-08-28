# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
#       ┌─────────────────────────┐
#       │     Configuration       │
#       └─────────────────────────┘
#  I understand this page... sometimes
{ config, lib, pkgs, inputs, ... }:


{
system.stateVersion = "26.05"; # DO NOT TOUCH
  imports = [
    ./hardware-configuration.nix # import hardware-configuration (partitions) and other configs.
  ];

  nix.settings = {        
    experimental-features = [ 
      "nix-command" 
      "flakes"
    ];
    substituters = ["https://hyprland.cachix.org"];
    trusted-substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="]; # Required so non-root users are allowed to use the above substituter/keys.
    trusted-users = ["root" "@wheel"]; # Use @wheel for all sudo users, or list your username explicitly.
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # Enable supported filesystems
  boot.supportedFilesystems = [ "btrfs" ];
  
#       ┌─────────────────────────┐
#       │           Boot          │
#       └─────────────────────────┘
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen; # Use zen OR latest kernel.

#       ┌─────────────────────────┐
#       │       Networking        │
#       └─────────────────────────┘

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true; # Configure network connections interactively with nmcli or nmtui.
  time.timeZone = "Australia/Brisbane"; # Set your time zone.

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

  programs.mtr.enable = true;   # Some programs need SUID wrappers, can be configured further or are
  programs.gnupg.agent = {      # started in user sessions.
    enable = true;
    enableSSHSupport = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

#       ┌─────────────────────────┐
#       │          Sound          │
#       └─────────────────────────┘ 

  security.rtkit.enable = true;
  services.pipewire = { # Enable sound.
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
#       ┌─────────────────────────┐
#       │          Users          │
#       └─────────────────────────┘

  users.users.teajhay = {
    isNormalUser = true;
    description = "Tea with a side of Jhay";
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    packages = with pkgs; [
      tree
    ];
  };

#       ┌─────────────────────────┐
#       │         Packages        │
#       └─────────────────────────┘ 

  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    ripgrep
    fd
    unzip
    nodejs
    gcc
    python3
    gnumake
    kitty
    tuigreet
    greetd
    gh
    unstable.noctalia
    unstable.noctalia-greeter
    fastfetch
    fzf
    lsd
    zsh-nix-shell
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    yazi
    rustdesk-flutter
  ];


#       ┌─────────────────────────┐
#       │      Applications       │
#       └─────────────────────────┘ 

  # Enable zsh 
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  
    shellAliases = {
      ll = "ls -l";
      edit = "sudo -e";
      update = "sudo nixos-rebuild switch";
    };
    
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
      ];
    };
  
    histSize = 10000;
    histFile = "$HOME/.zsh_history";
    setOptions = [
      "HIST_IGNORE_ALL_DUPS"
    ];
  };

  # Enable rustdesk 
  systemd.user.services.rustdesk = {
    description = "RustDesk remote desktop client";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.rustdesk-flutter}/bin/rustdesk --tray";
      Restart = "on-failure";
    };
  };

  # Enable Firefox 
  programs.firefox.enable = true;
#  programs.yazi.enable = true;
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    withUWSM = false;
    xwayland.enable = true;
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Optional, hint Electron apps to use Wayland:

  # Enable noctalia-greeter
  programs.noctalia-greeter = {
    enable = true;
    settings = {
      session.default = "hyprland";
    };
  };


}

