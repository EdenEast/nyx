{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.programs.jujutsu.enable = lib.mkEnableOption "jujutsu version control";

  config = lib.mkIf config.myHome.programs.jujutsu.enable {
    home.packages = with pkgs; [
      jujutsu
      jjui
      lazyjj
    ];
  };
}
