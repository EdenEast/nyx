{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.home.programs.jujutsu.enable = lib.mkEnableOption "jujutsu version control";

  config = lib.mkIf config.my.home.programs.jujutsu.enable {
    home.packages = with pkgs; [
      jujutsu
      jjui
      lazyjj
    ];
  };
}
