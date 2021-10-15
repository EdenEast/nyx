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

        bind-key v split-window -h
        bind-key s split-window -v
        bind-key | split-window -h
        bind-key - split-window -v

        # setting option without (on/off) will toggle option
        bind-key b set-option status
      '';
    };
  };
}
