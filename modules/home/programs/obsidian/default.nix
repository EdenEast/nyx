{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.home.programs.obsidian.enable = lib.mkEnableOption "note taking";

  config = lib.mkIf config.my.home.programs.obsidian.enable {
    home.packages = with pkgs; [
      obsidian
    ];
  };
}
