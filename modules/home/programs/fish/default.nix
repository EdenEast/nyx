{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.programs.fish = {
    # FIXME: This option should not be necessary and should be able to use `config.programs.fish.enable` instead however
    # this currently does not work as fish is set as the user's default shell and enabled in the nixos module and the
    # value is not passed or reconized by the home-manager module. Meaning that if it is set in the nixos module it
    # would not be enabled in the home-manager module
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable fish shell and related configuration.";
    };
  };

  config = lib.mkIf config.myHome.programs.fish.enable {
    programs.fish = {
      enable = true;

      shellAliases = import ../../base/shells/aliases.nix;
      functions = import ./functions.nix {inherit pkgs lib;};

      interactiveShellInit = let
        localDataPath = "${config.xdg.dataHome}/fish/config.fish";
      in
        # fish
        ''
          set -g fish_greeting

          # escape hatch from nix for experimentations
          if test -f ${localDataPath}
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
