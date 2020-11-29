{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.aspects.shell.bash;
in {
  options.nyx.aspects.shell.bash = {
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
    home.file.".bash_profile".source = ../../files/.bash_profile;
    home.file.".bashrc".source = ../../files/.bashrc;
    home.file.".inputrc".source = ../../files/.inputrc;
    home.file.".profile".source = ../../files/.profile;

    xdg.configFile."shell".source = ../../files/.config/shell;
    xdg.dataFile."bash/bashrc".text = ''
      ${cfg.initExtra}
    '';
    xdg.dataFile."bash/profile".text = ''
      ${cfg.profileExtra}
    '';
  };
}
