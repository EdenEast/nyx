{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.aspects.shell.broot;
in {
  options.nyx.aspects.shell.broot = {
    enable = mkEnableOption "broot configuration";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ broot ];
    # xdg.configFile."broot".source = ../../files/.config/broot;

    nyx.aspects.shell.bash.initExtra =
      mkIf config.nyx.aspects.shell.bash.enable ''
        eval "$(broot --print-shell-function bash)"
      '';

    nyx.aspects.shell.zsh.initExtra =
      mkIf config.nyx.aspects.shell.zsh.enable ''
        eval "$(broot --print-shell-function zsh)"
      '';
  };
}

