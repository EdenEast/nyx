{
  config,
  lib,
  ...
}: {
  options.myHome.programs.zoxide.enable = lib.mkEnableOption "cd alternative";

  config = lib.mkIf config.myHome.programs.zoxide.enable {
    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
    };
  };
}
