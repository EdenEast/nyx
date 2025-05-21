{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.nyx.modules.app.ghostty;
in {
  options.nyx.modules.app.ghostty = {
    enable = mkEnableOption "ghostty configuration";
  };

  config = mkIf cfg.enable {
    home.packages = [inputs.ghostty.packages."${pkgs.system}".default];
  };
}
