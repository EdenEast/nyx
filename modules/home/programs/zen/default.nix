{
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  options.my.home.programs.zen.enable = lib.mkEnableOption "zen web browser";

  config = lib.mkIf config.my.home.programs.zen.enable {
    programs.zen-browser.enable = true;
  };
}
