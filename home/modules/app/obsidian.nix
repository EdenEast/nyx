{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.modules.app.obsidian;
in
{
  options.nyx.modules.app.obsidian = {
    enable = mkEnableOption "Note taking application";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ obsidian ];
  };
}
