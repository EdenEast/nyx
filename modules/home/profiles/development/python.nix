{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.home.profiles.development.python;
in {
  options.my.home.profiles.development.python = {
    enable = lib.mkEnableOption "rust development";

    extraPackages = lib.mkOption {
      description = "List of extra packages to be installed";
      type = with lib.types; listOf package;
      default = with pkgs.python313Packages; [
        pip
        setuptools
      ];
    };
  };

  config = lib.mkIf config.my.home.profiles.development.python.enable {
    home.packages = with pkgs;
      [
        python314
        pipenv
      ]
      ++ cfg.extraPackages;

    my.home.profiles.development.enable = true;
  };
}
