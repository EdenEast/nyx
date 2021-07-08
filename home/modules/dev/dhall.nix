{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.modules.dev.dhall;
in
{
  options.nyx.modules.dev.dhall = {
    enable = mkEnableOption "dhall configuration";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dhall
      haskellPackages.dhall-bash
      haskellPackages.dhall-json
      haskellPackages.dhall-lsp-server
      haskellPackages.dhall-yaml
    ];
  };
}

