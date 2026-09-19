{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    (prismlauncher.override {
      jdks = with pkgs; [
        temurin-bin-8    # MC 1.7–1.12
        temurin-bin-17   # MC 1.17–1.20
        temurin-bin-21   # MC 1.20.5+
        unstable.temurin-bin-26
      ];
    })
  ];
}
