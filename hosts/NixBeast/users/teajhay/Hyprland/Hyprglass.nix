{
  inputs,
  pkgs,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;

  hyprglass =
    inputs.hyprland.inputs.nixpkgs.legacyPackages.${system}.callPackage
    ({
      lib,
      stdenv,
      fetchFromGitHub,
      pkg-config,
      wayland-scanner,
      wayland,
      hyprland,
    }:
      stdenv.mkDerivation (finalAttrs: {
        pname = "hyprglass";
        version = "5800533c964d9ad0c54f2111ecd9f859cfc6321c";

        src = fetchFromGitHub {
          owner = "hyprnux";
          repo = "hyprglass";
          rev = "${finalAttrs.version}";
          hash = "sha256-xM9ALzON6Wse+5m1UCBG3aeByp5AoHtytLbRyYKyUSw="; # keep your existing hash
        };

        nativeBuildInputs = [pkg-config wayland-scanner];
        buildInputs = [hyprland wayland] ++ hyprland.buildInputs;

        makeFlags = ["HYPRGLASS_VERSION=${finalAttrs.version}"];

        installPhase = ''
          runHook preInstall
          install -Dm755 hyprglass.so $out/lib/libhyprglass.so
          runHook postInstall
        '';

        meta = {
          homepage = "https://github.com/hyprnux/hyprglass";
          description = "Hyprland plugin that adds blur, lens, diffraction and refraction effects to transparent windows";
          license = lib.licenses.gpl3;
          platforms = lib.platforms.linux;
        };
      }))
    {
      hyprland = inputs.hyprland.packages.${system}.hyprland;
    };
in {
  environment.systemPackages = [hyprglass];
}
