{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.aspects.tmux;
in {
  options.nyx.aspects.tmux = { enable = mkEnableOption "tmux configuration"; };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.tmux ];
    xdg.configFile."tmux/tmux.conf".source = ../files/.config/tmux/tmux.conf;
  };
}

