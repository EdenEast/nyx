{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.modules.shell.tmux;
in
{
  options.nyx.modules.shell.tmux = {
    enable = mkEnableOption "tmux configuration";
  };

  # config = mkIf cfg.enable {
  #   home.packages = [ pkgs.tmux ];
  #   xdg.configFile."tmux/tmux.conf".source = ../../../config/.config/tmux/tmux.conf;
  # };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      aggressiveResize = true;
      baseIndex = 1;
      clock24 = true;
      disableConfirmationPrompt = true;
      keyMode = "vi";
      prefix = "C-a";
      terminal = "screen-256color";
      plugins = with pkgs.tmuxPlugins; [
        copycat
        extrakto
        nord
        prefix-highlight
        tmux-fzf
        vim-tmux-navigator
      ];
      extraConfig = ''
        set -ga terminal-overrides ",xterm-256color:Tc"
        set -g default-shell $SHELL              # use default shell
        set -sg escape-time 0                    # delay shorter
        set -sg history-limit 50000              # increase scrollback
        set -g mouse on                          # enable mouse mode

        source-file ~/.config/tmux/conf/keybindings.conf

        # left status is only length of 10
        set -g status-left-length 50
      '';
    };

    xdg.configFile."tmux/scripts" = {
      source = ../../../config/.config/tmux/scripts;
      recursive = true;
      executable = true;
    };
    xdg.configFile."tmux/conf" = {
      source = ../../../config/.config/tmux/conf;
      recursive = true;
      executable = true;
    };
  };
}

# extra plugins to look at
# - https://github.com/rothgar/awesome-tmux
#
# - https://github.com/wfxr/tmux-fzf-url
# - https://github.com/roosta/tmux-fuzzback
# - https://github.com/whame/tmux-modal
# - https://github.com/evnp/tmex
