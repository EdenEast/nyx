{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.modules.shell.mcfly;
  cfgHome = config.xdg.configHome;
in
{
  options.nyx.modules.shell.mcfly = {
    enable = mkEnableOption "fzf configuration";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.mcfly ];

    nyx.modules.shell.bash.initExtra =
      mkIf config.nyx.modules.shell.bash.enable ''
        eval "$(mcfly init bash)"
      '';

    nyx.modules.shell.zsh.initExtra =
      mkIf config.nyx.modules.shell.zsh.enable ''
        eval "$(mcfly init zsh)"
      '';
  };
}
