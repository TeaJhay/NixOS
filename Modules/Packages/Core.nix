{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    btop
    curl
    kitty
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    unstable.yazi
    tree
    unstable.vesktop
    sshfs
    lazyssh
    zoxide
  ];
}
