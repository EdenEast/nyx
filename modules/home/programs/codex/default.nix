{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.my.home.programs.codex;
in {
  options.my.home.programs.codex = {
    enable = lib.mkEnableOption "codex coding agent harness";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = [
        inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex
      ];
    };
  };
}
