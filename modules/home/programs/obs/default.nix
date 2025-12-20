{
  config,
  lib,
  ...
}: {
  options.myHome.programs.obs.enable = lib.mkEnableOption "Video recording/streaming";

  config = lib.mkIf config.myHome.programs.obs.enable {
    programs.obs-studio.enable = true;
  };
}
