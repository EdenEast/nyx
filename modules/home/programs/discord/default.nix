{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.home.programs.discord.enable = lib.mkEnableOption "discord app";

  config = lib.mkIf config.my.home.programs.discord.enable {
    home.packages = with pkgs; [
      discord
    ];
  };
}
