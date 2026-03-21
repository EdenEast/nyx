{
  config,
  lib,
  ...
}: {
  options.my.home.programs.claude = {
    enable = lib.mkEnableOption "claude ai";
  };

  config = lib.mkIf config.my.home.programs.claude.enable {
    programs.claude-code = {
      enable = true;
    };
  };
}
