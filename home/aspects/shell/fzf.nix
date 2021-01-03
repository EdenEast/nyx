{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.aspects.shell.fzf;
  cfgHome = config.xdg.configHome;
in {
  options.nyx.aspects.shell.fzf = {
    enable = mkEnableOption "fzf configuration";

    enableGit = mkOption {
      type = types.bool;
      default = true;
      description = "Enable key-bindings for git";
    };

    useDefaultFd = mkOption {
      type = types.bool;
      default = true;
      description = "Use fd as default find";
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
            optionalString (cfg.enableGit) ''
              . ${cfgHome}/fzf/functions.sh
              . ${cfgHome}/fzf/key-bindings.bash
            ''
          }
        fi
      '';

    nyx.aspects.shell.bash.profileExtra =
      mkIf config.nyx.aspects.shell.bash.enable ''
          ${optionalString (cfg.useDefaultFd) ''
            export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
            export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
            export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
          ''}
      '';

    nyx.aspects.shell.zsh.initExtra =
      mkIf config.nyx.aspects.shell.zsh.enable ''
        if [[ $options[zle] = on ]]; then
          . ${pkgs.fzf}/share/fzf/completion.zsh
          . ${pkgs.fzf}/share/fzf/key-bindings.zsh
          ${
            optionalString (cfg.enableGit) ''
              emulate bash -c ". ${cfgHome}/fzf/functions.sh"
              . ${cfgHome}/fzf/key-bindings.zsh
            ''
          }
        fi
      '';

    nyx.aspects.shell.zsh.profileExtra =
      mkIf config.nyx.aspects.shell.zsh.enable ''
          ${optionalString (cfg.useDefaultFd) ''
            export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
            export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
            export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
          ''}
      '';
  };
}
