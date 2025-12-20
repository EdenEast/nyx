{
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  options.myHome.programs.zen.enable = lib.mkEnableOption "zen web browser";

  config = lib.mkIf config.myHome.programs.zen.enable {
    programs.zen-browser.enable = true;
  };
}
