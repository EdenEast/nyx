{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.aspects.shell.fzf;
  cfgHome = config.xdg.configHome;
in {
  options.nyx.aspects.shell.fzf = {
    enable = mkEnableOption "fzf configuration";
    gitIntegration = mkOption {
      type = types.bool;
      default = true;
      description = "Enable key-bindings for git";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.fzf ];

    xdg.configFile."fzf".source = ../../files/.config/fzf;

    nyx.aspects.shell.bash.initExtra =
      mkIf config.nyx.aspects.shell.bash.enable ''
        if [[ :$SHELLOPTS: =~ :(vi|emacs): ]]; then
          . ${pkgs.fzf}/share/fzf/completion.bash
          . ${pkgs.fzf}/share/fzf/key-bindings.bash
          ${
            optionalString (cfg.gitIntegration) ''
              . ${cfgHome}/fzf/functions.sh
              . ${cfgHome}/fzf/key-bindings.bash
            ''
          }
        fi
      '';

    nyx.aspects.shell.zsh.initExtra =
      mkIf config.nyx.aspects.shell.zsh.enable ''
        if [[ $options[zle] = on ]]; then
          . ${pkgs.fzf}/share/fzf/completion.zsh
          . ${pkgs.fzf}/share/fzf/key-bindings.zsh
          ${
            optionalString (cfg.gitIntegration) ''
              emulate bash -c ". ${cfgHome}/fzf/functions.sh"
              . ${cfgHome}/fzf/key-bindings.zsh
            ''
          }
        fi
      '';
  };
}
