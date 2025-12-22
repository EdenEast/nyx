{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.programs.fish.enable = lib.mkEnableOption "fish shell";

  config = lib.mkIf config.myHome.programs.fish.enable {
    programs.fish = {
      enable = true;

      shellAliases = import ./aliases.nix;
      functions = import ./functions.nix {inherit pkgs lib;};

      interactiveShellInit = ''
        set -g fish_greeting
      '';
    };

    home.packages = with pkgs; [
      fishPlugins.fzf-fish
      fishPlugins.colored-man-pages
    ];
  };
}
