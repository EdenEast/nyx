{
  config,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.dankMaterialShell.homeModules.dank-material-shell
  ];

  options.my.home.services.dms = {
    enable = lib.mkEnableOption "Dank material quick shell";
  };

  config = lib.mkIf config.my.home.services.dms.enable {
    programs.dank-material-shell = {
      enable = true;

      # Core features
      # https://danklinux.com/docs/dankmaterialshell/nixos-flake#feature-toggles
      enableSystemMonitoring = true; # System monitoring widgets (dgop)
      enableDynamicTheming = true; # Wallpaper-based theming (matugen)
      enableAudioWavelength = true; # Audio visualizer (cava)
      enableCalendarEvents = false; # Calendar integration (khal) - disabled by default
    };
  };
}
