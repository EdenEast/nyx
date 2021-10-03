{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.nyx.modules.shell.nushell;
in
{
  options.nyx.modules.shell.nushell = {
    enable = mkEnableOption "neovim configuration";
  };
  config = mkIf cfg.enable {
    programs.nushell.enable = true;
  };
}
