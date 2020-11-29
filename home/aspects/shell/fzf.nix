{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.aspects.shell.fzf;
in {
  options.nyx.aspects.shell.fzf = { enable = mkEnableOption "fzf configuration"; };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.fzf ];

    nyx.aspects.shell.bash.initExtra = ''
      if [[ :$SHELLOPTS: =~ :(vi|emacs): ]]; then
        . ${pkgs.fzf}/share/fzf/completion.bash
        . ${pkgs.fzf}/share/fzf/key-bindings.bash
      fi
    '';
  };
}
