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
    fonts.packages = with pkgs.nerd-fonts; [
      jetbrains-mono
      hack
      gohufont
      meslo-lg
      ubuntu-mono
    ];
  };
}
