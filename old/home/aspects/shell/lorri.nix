{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.aspects.shell.lorri;
in {
  options.nyx.aspects.shell.lorri = {
    enable = mkEnableOption "lorri configuration";
  };

  config = mkIf cfg.enable { services.lorri.enable = true; };
}
