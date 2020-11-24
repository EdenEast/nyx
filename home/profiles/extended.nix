{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.profiles.extended;
in {
  options.nyx.profiles.extended = {
    enable = mkEnableOption "extended profile";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        # Power consumption and management diagnosis tool.
        powertop
        # Bandwidth monitor and rate estimator.
        bmon
        # Top-like I/O monitor.
        iotop
        # Dump traffic on a network.
        tcpdump
        # A command-line tool to generate, analyze, convert and manipulate colors.
        pastel
        # Tool for indexing, slicing, analyzing, splitting and joining CSV files.
        xsv
        # Command line image viewer
        viu
        # Tool for discovering and probing hosts on a computer network
        arping
        # Recover dead disks :(
        ddrescue
        # Keybase
        keybase
        # Hosted binary caches
        cachix
      ];
    };

    nyx.aspects = {
      lf.enable = true;
      zsh.enable = true;
    };
  };
}
