{
  config,
  lib,
  ...
}: {
  options.my.home.programs.yazi.enable = lib.mkEnableOption "terminal explorer";

  config = lib.mkIf config.my.home.programs.yazi.enable {
    programs.yazi = {
      enable = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
    };
  };
}
