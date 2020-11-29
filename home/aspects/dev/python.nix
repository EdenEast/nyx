{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.aspects.python;
in {
  options.nyx.aspects.python.enable = mkEnableOption "python configuration";

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
      PIP_CONFIG_FILE = "$XDG_CONFIG_HOME/pip/pip.conf";
      PIP_LOG_FILE = "$XDG_DATA_HOME/pip/log";
      PYLINTHOME = "$XDG_DATA_HOME/pylint";
      PYLINTRC = "$XDG_CONFIG_HOME/pylint/pylintrc";
      PYTHONSTARTUP = "$XDG_CONFIG_HOME/python/pythonrc";
    };
  };
}
