{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.aspects.dev.go;
in {
  options.nyx.aspects.dev.go = { enable = mkEnableOption "go configuration"; };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      go
      # linters and static analysis
      go-tools
    ];

    home = { };
  };
}

