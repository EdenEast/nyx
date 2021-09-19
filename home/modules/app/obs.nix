{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.modules.app.obs;
in
{
  options.nyx.modules.app.obs = {
    enable = mkEnableOption "Open Broadcast Software";
  };

  config = mkIf cfg.enable {
    programs.obs-studio.enable = true;
  };
}
