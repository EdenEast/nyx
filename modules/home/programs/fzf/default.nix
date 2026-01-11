{
  config,
  lib,
  ...
}: {
  options.my.home.programs.fzf.enable = lib.mkEnableOption "shell prompt";

  config = lib.mkIf config.my.home.programs.fzf.enable {
    programs.fzf = {
      enable = true;
      changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
      defaultCommand = "fd --type f --hidden --follow --exclude .git";

      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
  };
}
