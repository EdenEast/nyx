{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.aspects.fzf;
in
{
  options.nyx.aspects.fzf = {
    enable = mkEnableOption "fzf configuration";
  };

  config = mkIf cfg.enable {
    programs.fzf.enable = true;
  };
}
