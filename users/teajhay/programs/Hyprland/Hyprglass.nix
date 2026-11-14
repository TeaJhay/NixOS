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
        version = "317ed8c1b06be00990ccdca02bf9ade936f47f13";

        src = fetchFromGitHub {
          owner = "hyprnux";
          repo = "hyprglass";
          rev = "${finalAttrs.version}";
          hash = "sha256-zA7q8r/FAURwg2GnaPsKxLvbnsnOXmhYzUeOUezLuPk="; # keep your existing hash
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
