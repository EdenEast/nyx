{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.aspects.ssh;
in {
  options.nyx.aspects.ssh = { enable = mkEnableOption "ssh configuration"; };

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;

      controlMaster = "auto";
      controlPath = "~/.ssh/sockets/%r@%h-%p";
      extraOptionOverrides = { "Include" = "~/.ssh/config.local"; };
      hashKnownHosts = true;
    };
  };
}

