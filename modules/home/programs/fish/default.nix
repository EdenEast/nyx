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

      interactiveShellInit = let
        localDataPath = lib.strings.concatStringsSep "/" [
          config.home.homeDirectory
          config.xdg.dataFile."fish/config.fish".target
        ];
      in
        # fish
        ''
          set -g fish_greeting

          # escape hatch from nix for experimentations
          if test ${localDataPath}
            source ${localDataPath}
          end
        '';
    };

    # Required to be defined to be callable but disabling so file does not get generated
    xdg.dataFile."fish/config.fish".enable = false;

    home.packages = with pkgs; [
      fishPlugins.fzf-fish
      fishPlugins.colored-man-pages
    ];
  };
}
