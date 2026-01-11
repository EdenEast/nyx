{
  config,
  lib,
  ...
}: {
  options.my.home.programs.zoxide.enable = lib.mkEnableOption "cd alternative";

  config = lib.mkIf config.my.home.programs.zoxide.enable {
    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
    };
  };
}
