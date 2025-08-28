{
  config,
  lib,
  inputs,
  ...
}:
with lib; let
  cfg = config.nyx.modules.app.zen-browser;
in {
  imports = [
    inputs.zen-browser.homeModules.beta
  ];
  options.nyx.modules.app.zen-browser = {
    enable = mkEnableOption "zen-browser configuration";
  };

  config = mkIf cfg.enable {
    programs.zen-browser.enable = true;
  };
}
