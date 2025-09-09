{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.nyx.modules.shell.jujutsu;
in {
  options.nyx.modules.shell.jujutsu = {
    enable = mkEnableOption "jujutsu configuration";
  };

  config = mkIf cfg.enable {
    home.packages = [pkgs.jujutsu pkgs.jjui pkgs.lazyjj];
  };
}
