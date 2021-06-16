{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.aspects.shell.repo;
in {
  options.nyx.aspects.shell.repo = {
    enable = mkEnableOption "repo configuration";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.repo ];
    # xdg.configFile."tmux/tmux.conf".source = ../../files/.config/tmux/tmux.conf;
  };
}

