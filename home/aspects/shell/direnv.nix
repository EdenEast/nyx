{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.aspects.shell.direnv;
in {
  options.nyx.aspects.shell.direnv = {
    enable = mkEnableOption "direnv configuration";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ direnv nix-direnv ];

    nyx.aspects.shell.bash.initExtra =
      mkIf config.nyx.aspects.shell.bash.enable ''
        eval "$(direnv hook bash)"
      '';

    nyx.aspects.shell.zsh.initExtra =
      mkIf config.nyx.aspects.shell.zsh.enable ''
        eval "$(direnv hook zsh)"
      '';
  };
}
