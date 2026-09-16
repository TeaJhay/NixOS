{ pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    btop
    curl
    kitty
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    unstable.yazi
    tree
    vesktop
    sshfs
    lazyssh
    zoxide
  ];
}
