{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.nyx.modules.shell.yazi;
in {
  options.nyx.modules.shell.yazi = {
    enable = mkEnableOption "yazi configuration";
  };

  config = mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };
  };
}
