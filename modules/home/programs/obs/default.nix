{
  config,
  lib,
  ...
}: {
  options.my.home.programs.obs.enable = lib.mkEnableOption "Video recording/streaming";

  config = lib.mkIf config.my.home.programs.obs.enable {
    programs.obs-studio.enable = true;
  };
}
