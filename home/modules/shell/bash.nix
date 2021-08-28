{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.modules.shell.bash;
in
{
  options.nyx.modules.shell.bash = {
    enable = mkEnableOption "bash configuration";

    profileExtra = mkOption {
      default = "";
      type = types.lines;
      description = ''
        Extra commands that should be run when initializing a login
        shell.
      '';
    };

    initExtra = mkOption {
      default = "";
      type = types.lines;
      description = ''
        Extra commands that should be run when initializing an
        interactive shell.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.file.".bash_profile".source = ../../../config/.bash_profile;
    home.file.".bashrc".source = ../../../config/.bashrc;
    home.file.".inputrc".source = ../../../config/.inputrc;
    home.file.".profile".source = ../../../config/.profile;

    xdg.configFile."shell".source = ../../../config/.config/shell;
    xdg.dataFile."bash/nyx_bashrc".text = ''
      # auto genreated by nyx

      ${cfg.initExtra}
    '';
    xdg.dataFile."bash/nyx_profile".text = ''
      # auto genreated by nyx

      ${cfg.profileExtra}
    '';
  };
}
