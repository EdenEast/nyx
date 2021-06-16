{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.aspects.dev.python;
  configHome = config.xdg.configHome;
  dataHome = config.xdg.dataHome;
in {
  options.nyx.aspects.dev.python.enable = mkEnableOption "python configuration";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      python37
      python37Packages.black
      python37Packages.jedi
      python37Packages.pip
      python37Packages.poetry
      python37Packages.pylint
      python37Packages.setuptools
    ];

    home.sessionVariables = {
      PIP_CONFIG_FILE = "${configHome}/pip/pip.conf";
      PIP_LOG_FILE = "${dataHome}/pip/log";
      PYLINTHOME = "${dataHome}/pylint";
      PYLINTRC = "${configHome}/pylint/pylintrc";
      PYTHONSTARTUP = "${configHome}/python/pythonrc";
    };
  };
}
