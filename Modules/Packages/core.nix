{ pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    git
    btop
    curl
    kitty
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    yazi
    tree
    vesktop
    sshfs
    lazyssh
  ];
} 
