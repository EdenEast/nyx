{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.modules.shell.fzf;
  cfgHome = config.xdg.configHome;
in
{
  options.nyx.modules.shell.fzf = {
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

    xdg.configFile."fzf".source = ../../../config/.config/fzf;

    nyx.modules.shell.bash.initExtra =
      mkIf config.nyx.modules.shell.bash.enable ''
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

    nyx.modules.shell.bash.profileExtra =
      mkIf config.nyx.modules.shell.bash.enable ''
        ${optionalString (cfg.useDefaultFd) ''
          export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
          export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
          export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
        ''}
      '';

    nyx.modules.shell.zsh.initExtra =
      mkIf config.nyx.modules.shell.zsh.enable ''
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

    nyx.modules.shell.zsh.profileExtra =
      mkIf config.nyx.modules.shell.zsh.enable ''
        ${optionalString (cfg.useDefaultFd) ''
          export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
          export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
          export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
        ''}
      '';
  };
}
