{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.aspects.shell.zoxide;
in {
  options.nyx.aspects.shell.zoxide = {
    enable = mkEnableOption "zoxide configuration";
  };

  config = mkIf cfg.enable { home.packages = [ pkgs.zoxide ]; };
}
