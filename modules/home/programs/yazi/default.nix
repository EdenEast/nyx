{
  config,
  lib,
  ...
}: {
  options.myHome.programs.yazi.enable = lib.mkEnableOption "terminal explorer";

  config = lib.mkIf config.myHome.programs.yazi.enable {
    programs.yazi = {
      enable = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
    };
  };
}
