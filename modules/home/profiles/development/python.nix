{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.profiles.development.python = {
    enable = lib.mkEnableOption "rust development";

    extraPackages = lib.mkOption {
      description = "List of extra packages to be installed";
      type = with lib.types; listOf package;
      default = with pkgs.python313Packages; [
        black
        jedi
        pip
        poetry
        pylint
        setuptools
      ];
    };
  };

  config = lib.mkIf config.myHome.profiles.development.python.enable {
    home.packages = with pkgs;
      [
        python313
        pipenv
      ]
      ++ cfg.extraPackages;

    myHome.profiles.development.enable = true;
  };
}
