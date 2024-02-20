{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.modules.app.obsidian;
  obsidian = lib.throwIf (lib.versionOlder "1.4.16" pkgs.obsidian.version) "Obsidian no longer requires EOL Electron" (
    pkgs.obsidian.override {
      electron = pkgs.electron_25.overrideAttrs (_: {
        preFixup = "patchelf --add-needed ${pkgs.libglvnd}/lib/libEGL.so.1 $out/bin/electron"; # NixOS/nixpkgs#272912
        meta.knownVulnerabilities = [ ]; # NixOS/nixpkgs#273611
      });
    }
  );
in
{
  options.nyx.modules.app.obsidian = {
    enable = mkEnableOption "Note taking application";
  };

  config = mkIf cfg.enable {
    home.packages = [ obsidian ];
  };
}
