{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.modules.shell.direnv;
in
{
  options.nyx.modules.shell.direnv = {
    enable = mkEnableOption "direnv configuration";
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    nyx.modules.shell.bash.initExtra =
      mkIf config.nyx.modules.shell.bash.enable ''
        eval "$(direnv hook bash)"
      '';

    nyx.modules.shell.zsh.initExtra =
      mkIf config.nyx.modules.shell.zsh.enable ''
        eval "$(direnv hook zsh)"
      '';
  };
}
