{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.nyx.profiles.extended;
in {
  options.nyx.profiles.extended = {
    enable = mkEnableOption "extended profile";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          # Bandwidth monitor and rate estimator.
          bmon
          # Command line image viewer
          viu
          # Tool for discovering and probing hosts on a computer network
          arping
          # Recover dead disks :(
          ddrescue
        ]
        ++ optionals pkgs.stdenv.isLinux [
          # Power consumption and management diagnosis tool.
          powertop
          # Top-like I/O monitor.
          iotop
        ];
    };

    nyx.modules = {
      shell.direnv.enable = true;
      shell.fzf.enable = true;
      shell.glow.enable = true;
      # shell.keybase.enable = true;
      shell.lf.enable = true;
      # shell.mcfly.enable = true;
      # shell.repo.enable = true;
      shell.tmux.enable = true;
      shell.zellij.enable = true;
      shell.zoxide.enable = true;
      shell.zsh.enable = true;
    };
  };
}
