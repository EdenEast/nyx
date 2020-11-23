{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.aspects.fzf;
in {
  options.nyx.aspects.fzf = { enable = mkEnableOption "fzf configuration"; };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.fzf ];

    nyx.aspects.bash.initExtra = ''
      if [[ :$SHELLOPTS: =~ :(vi|emacs): ]]; then
        . ${pkgs.fzf}/share/fzf/completion.bash
        . ${pkgs.fzf}/share/fzf/key-bindings.bash
      fi
    '';
  };
}
