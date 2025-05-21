{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.nyx.modules.shell.lorri;
in {
  options.nyx.modules.shell.lorri = {
    enable = mkEnableOption "lorri configuration";
  };

  config = mkIf cfg.enable {services.lorri.enable = true;};
}
