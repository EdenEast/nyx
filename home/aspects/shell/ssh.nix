{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.aspects.shell.ssh;
in {
  options.nyx.aspects.shell.ssh = {
    enable = mkEnableOption "ssh configuration";
  };

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

