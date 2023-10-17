{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.modules.shell.zoxide;
in
{
  options.nyx.modules.shell.zoxide = {
    enable = mkEnableOption "zoxide configuration";
  };

  config = mkIf cfg.enable {
    programs.zoxide.enable = true;
    # home.packages = [ pkgs.zoxide ];
  };
}
