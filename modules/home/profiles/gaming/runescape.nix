{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.home.profiles.gaming.runescape.enable = lib.mkEnableOption "RuneScape tooling";

  config = lib.mkIf config.my.home.profiles.gaming.runescape.enable {
    home.packages = with pkgs; [
      jagex-launcher
      runelite
    ];

    my.home.profiles.gaming.enable = true;
  };
}
