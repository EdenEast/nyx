{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.configs.fzf;
in
{
  options.nyx.configs.fzf = {
    enable = mkEnableOption "fzf configuration";
  };

  config = mkIf cfg.enable {
    programs.fzf.enable = true;
  };
}
