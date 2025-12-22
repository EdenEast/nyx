{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.programs.starship.enable = lib.mkEnableOption "shell prompt";

  config = lib.mkIf config.myHome.programs.starship.enable {
    programs.starship = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      enableInteractive = false;
      package = pkgs.starship;
      settings = lib.importTOML ../../../../config/.config/starship/starship.toml;
    };
  };
}
