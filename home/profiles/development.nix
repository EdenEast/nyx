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
      # Codebase statistics.
      tokei
      # Shell script analysis tool
      shellcheck
    ];

    nyx.aspects = {
      cc.enable = true;
      keybase.enable = true;
      node.enable = true;
      rust.enable = true;
    };
  };
}
