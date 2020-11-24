{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.aspects.zoxide;
in {
  options.nyx.aspects.zoxide = {
    enable = mkEnableOption "zoxide configuration";
  };

  config = mkIf cfg.enable { home.packages = [ pkgs.zoxide ]; };
}
