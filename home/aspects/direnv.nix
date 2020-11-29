{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.aspects.direnv;
in {
  options.nyx.aspects.direnv = {
    enable = mkEnableOption "direnv configuration";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ direnv ];

    nyx.aspects.bash.initExtra = mkIf config.nyx.aspects.bash.enable ''
      eval "$(direnv hook bash)"
    '';

    nyx.aspects.zsh.initExtra = mkIf config.nyx.aspects.zsh.enable ''
      eval "$(direnv hook zsh)"
    '';
  };
}
