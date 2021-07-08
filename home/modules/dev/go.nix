{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.modules.dev.go;
in
{
  options.nyx.modules.dev.go = { enable = mkEnableOption "go configuration"; };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        go
        # linters and static analysis
        go-tools
      ];

      sessionVariables = {
        GOPATH = "${config.xdg.dataHome}/go";
        GOBIN = "${config.xdg.dataHome}/go/bin";
      };
    };
  };
}

