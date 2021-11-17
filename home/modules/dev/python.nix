{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.modules.dev.python;
  configHome = config.xdg.configHome;
  dataHome = config.xdg.dataHome;
in
{
  options.nyx.modules.dev.python = {
    enable = mkEnableOption "python configuration";

    extraPackages = mkOption {
      description = "List of extra packages to be installed";
      type = with types; listOf package;
      default = with pkgs.python39Packages; [
        black
        jedi
        pip
        poetry
        pylint
        setuptools
      ];
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      python39
      pipenv
    ] ++ cfg.extraPackages;

    # home.sessionVariables = {
    #   PIP_CONFIG_FILE = "${configHome}/pip/pip.conf";
    #   PIP_LOG_FILE = "${dataHome}/pip/log";
    #   PYLINTHOME = "${dataHome}/pylint";
    #   PYLINTRC = "${configHome}/pylint/pylintrc";
    #   PYTHONSTARTUP = "${configHome}/python/pythonrc";
    # };
  };
}
