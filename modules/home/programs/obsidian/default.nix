{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.programs.obsidian.enable = lib.mkEnableOption "note taking";

  config = lib.mkIf config.myHome.programs.obsidian.enable {
    home.packages = with pkgs; [
      obsidian
    ];
  };
}
