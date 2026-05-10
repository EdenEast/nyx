{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.home.programs.pi = {
    enable = lib.mkEnableOption "pi coding agent harness";
  };

  config = lib.mkIf config.my.home.programs.pi.enable {
    home = {
      packages = [
        pkgs.master.pi-coding-agent
      ];

      sessionVariables = {
        PI_CODING_AGENT_DIR = "${config.xdg.configHome}/pi";
      };
    };
  };
}
