{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.home.programs.starship.enable = lib.mkEnableOption "shell prompt";

  config = lib.mkIf config.my.home.programs.starship.enable {
    programs.starship = {
      enable = true;
      configPath = "${config.xdg.configHome}/starship/starship.toml";
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      enableInteractive = false;
      package = pkgs.starship;
      settings = lib.importTOML ../../../../config/.config/starship/starship.toml;
    };
  };
}
