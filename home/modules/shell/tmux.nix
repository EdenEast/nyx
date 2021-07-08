{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.modules.shell.tmux;
in
{
  options.nyx.modules.shell.tmux = {
    enable = mkEnableOption "tmux configuration";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.tmux ];
    xdg.configFile."tmux/tmux.conf".source = ../../../config/.config/tmux/tmux.conf;
  };
}

