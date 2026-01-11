{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.home.profiles.development.python = {
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

  config = lib.mkIf config.my.home.profiles.development.python.enable {
    home.packages = with pkgs;
      [
        python313
        pipenv
      ]
      ++ cfg.extraPackages;

    my.home.profiles.development.enable = true;
  };
}
