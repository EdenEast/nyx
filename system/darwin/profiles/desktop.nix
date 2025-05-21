{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.nyx.profiles.desktop;
in {
  options.nyx.profiles.desktop = {
    enable = mkEnableOption "desktop profile";
  };

  config = mkIf cfg.enable {
    fonts = {
      packages = with pkgs; [
        (
          nerdfonts.override {
            fonts = ["JetBrainsMono" "Hack" "Gohu" "Meslo" "UbuntuMono"];
          }
        )
      ];
    };
  };
}
