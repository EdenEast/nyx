{
  config,
  lib,
  ...
}: {
  options.myHome.programs.zsh.enable = lib.mkEnableOption "zsh shell";

  config = lib.mkIf config.myHome.programs.zsh.enable {
    programs.zsh = {
      enable = true;
    };
  };
}
