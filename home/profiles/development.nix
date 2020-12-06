{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.profiles.development;
in {
  options.nyx.profiles.development.enable =
    mkEnableOption "development configuration";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Benchmarking.
      hyperfine
      # Just a command runner
      just
      # Shell script analysis tool
      shellcheck
      # Codebase statistics.
      tokei
    ];

    nyx.aspects = {
      dev.cc.enable = true;
      dev.go.enable = true;
      dev.lua.enable = true;
      dev.node.enable = true;
      dev.python.enable = true;
      dev.rust.enable = true;
      shell.direnv.enable = true;
      shell.keybase.enable = true;
    };
  };
}
