{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.home.programs.ghostty.enable = lib.mkEnableOption "ghostty terminal emulator";

  config = lib.mkIf config.my.home.programs.ghostty.enable {
    programs.ghostty = {
      enable = true;
      package = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin pkgs.ghostty-bin;

      settings = {
        gtk-single-instance = lib.mkIf pkgs.stdenv.hostPlatform.isLinux true;
        quit-after-last-window-closed = lib.mkIf pkgs.stdenv.hostPlatform.isLinux false;
      };
    };
  };
}
