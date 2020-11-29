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
      cc.enable = true;
      direnv.enable = true;
      keybase.enable = true;
      lua.enable = true;
      node.enable = true;
      python.enable = true;
      rust.enable = true;
    };
  };
}
