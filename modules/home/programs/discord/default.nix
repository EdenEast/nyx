{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.programs.discord.enable = lib.mkEnableOption "discord app";

  config = lib.mkIf config.myHome.programs.discord.enable {
    home.packages = with pkgs; [
      discord
    ];
  };
}
