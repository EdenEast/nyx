{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  options.my.home.programs.pi = {
    enable = lib.mkEnableOption "pi coding agent harness";
  };

  config = lib.mkIf config.my.home.programs.pi.enable {
    home = {
      packages = [
        inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi
      ];

      # sessionVariables = {
      #   PI_CODING_AGENT_DIR = "${config.xdg.configHome}/pi";
      # };
    };
  };
}
