# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
#       ┌─────────────────────────┐
#       │     Configuration       │
#       └─────────────────────────┘
#  I am starting to understand! Wipe time!
{
  pkgs,
  inputs,
  ...
}:

{
  system.stateVersion = "26.05"; # DO NOT TOUCH
  imports = [
    ./hosts/NixBeast # import hardware-configuration (partitions) and other configs.
    ./Modules/Filesystem
  #./Modules/Packages
  ];
  nixpkgs.config.allowUnfree = true;


  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  #       ┌─────────────────────────┐
  #       │   Boot/Kernel/Graphics  │
  #       └─────────────────────────┘
  boot.loader.systemd-boot.enable = true;
  boot.initrd.systemd.emergencyAccess = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen; # Use zen OR latest kernel.
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelParams = [
    #  "video=DP-1:1920x1080@60"
    #  "video=HDMI-A-1:3840x2160@120"
  ];
  services.lact.enable = true;
  #       ┌─────────────────────────┐
  #       │       Networking        │
  #       └─────────────────────────┘

  time.timeZone = "Australia/Brisbane"; # Set your time zone.
networking = {
  hostName = "NixBeast";

  networkmanager = {
    enable = true;
    insertNameservers = [ "10.0.1.101" "1.1.1.1" ];

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
          wake-on-lan = 1; # magic packet; see note below
        };
      };
    };
  };
};

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
  services.udisks2.enable = true;
  programs.mtr.enable = true; # Some programs need SUID wrappers, can be configured further or are
  programs.gnupg.agent = {
    # started in user sessions.
    enable = true;
    enableSSHSupport = true;

    settings = {
      default-cache-ttl = 28800;
      max-cache-ttl = 28800;
      default-cache-ttl-ssh = 28800;
      max-cache-ttl-ssh = 28800;
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    2049
    22
  ];
  networking.firewall.allowedUDPPorts = [
    2049
    22
  ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  #       ┌─────────────────────────┐
  #       │          Sound          │
  #       └─────────────────────────┘

  security.rtkit.enable = true;
  services.pipewire = {
    # Enable sound.
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  #       ┌─────────────────────────┐
  #       │          Users          │
  #       └─────────────────────────┘

  # imports the hjemModule
  hjem.extraModules = [ inputs.hjem-impure.hjemModules.default ];
  # enable hjem-impure
  hjem.users.teajhay.impure.enable = true;
  NixBeast.users.enabled = [
    "teajhay"
  ];
  users.users.teajhay = {
    home = "/home/teajhay";
    isNormalUser = true;
    hashedPasswordFile = "/persistent/passwords/user/linux";
    #initialPassword = "changeme";
    description = "Tea with a side of Jhay";
    extraGroups = [
      "wheel"
      "networkmanager"
    ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };
  #       ┌─────────────────────────┐
  #       │         Packages        │
  #       └─────────────────────────┘

  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    nixfmt
    alejandra
    nil
    ripgrep
    fd
    unzip
    nodejs
    gcc
    nixd
    python3
    gnumake
    # tuigreet  # Add to TUI-based host
    greetd
    gh
    fastfetch
    fzf
    lsd
    zsh-nix-shell
    prismlauncher
    starship
    age
    hyprcursor
    unstable.pear-desktop
    unstable.quickshell
    qt6.qtwayland
    libnotify
    slurp
    swappy
    grim
    wl-clipboard
    playerctl
    krita
    bitwarden-cli
    hyprpicker
    tesseract
    zbar
    imagemagick
    jq
    mpv
    translate-shell
    udiskie
    lynx
    loupe
  ];

  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    ibm-plex
    nerd-fonts.iosevka
  ];


  fonts.fontconfig = {
    defaultFonts = {
      serif = [ "IBM Plex Serif" ];
      sansSerif = [ "IBM Plex Sans" ];
      monospace = [ "Iosevka Nerd Font" ]; 
    };
  };

  environment.sessionVariables = {
    EDITOR = "nvim";
    STARSHIP_CONFIG = "/home/teajhay/.config/starship/starship.toml";
    NIXOS_CONFIG = "/persistent/home/teajhay/nixos/";
  };
  #       ┌─────────────────────────┐
  #       │      Applications       │
  #       └─────────────────────────┘

  nixpkgs.overlays = [
    (final: prev: {
      prismlauncher = prev.prismlauncher.override {
        # 1. Provide all the Java versions you need for different Minecraft versions
        jdks = with prev; [
          temurin-bin-8 # For old Minecraft versions (1.7 - 1.12)
          temurin-bin-17 # For Minecraft 1.17 - 1.20
          temurin-bin-21 # For Minecraft 1.20.5+
          final.unstable.temurin-bin-26
        ];
      };
    })
  ];
  programs.gamemode.enable = true;
  programs.steam.enable = true;


  programs.git = {
    enable = true;
    config = {
      user = {
        name= "Teajhay";
      };
    };
  };
  programs.thunderbird.enable = true;
  #programs.starship = {
  #    enable = true;
  #    settings = lib.mkMerge [
  #      (builtins.fromTOML
  #        (builtins.readFile "/home/teajhay/.config/starship/starship.toml"
  #      ))
  #    ];
  #  };
  services.flatpak.enable = true;
  # Enable zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      gitbeam = "git commit -a -m 'edits' && git push";
      edit = "sudo -E nvim";
      update-pers = "sudo nixos-rebuild switch --show-trace --flake /persistent/home/NixOS#nixos";
      update = "sudo nixos-rebuild switch --show-trace --flake #NixBeast";
      nmtui = "env NEWT_COLORS='root=white,black border=black,lightgray window=lightgray,lightgray title=black,lightgray button=black,cyan' nmtui";
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


}
