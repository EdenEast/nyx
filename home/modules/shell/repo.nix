{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.modules.shell.repo;
in {
  options.nyx.modules.shell.repo = {
    enable = mkEnableOption "repo configuration";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.repo ];
    # xdg.configFile."tmux/tmux.conf".source = ../../../config/.config/tmux/tmux.conf;
  };
}

