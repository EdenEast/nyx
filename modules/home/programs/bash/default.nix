{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  options.my.home.programs.bash = {
    # FIXME: This option should not be necessary and should be able to use `config.programs.bash.enable` instead however
    # this currently does not work as bash is set as the user's default shell and enabled in the nixos module and the
    # value is not passed or reconized by the home-manager module. Meaning that if it is set in the nixos module it
    # would not be enabled in the home-manager module
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable bash shell and related configuration.";
    };
  };

  config = lib.mkIf config.my.home.programs.bash.enable (lib.mkMerge [
    {
      programs.bash = {
        enable = true;

        enableCompletion = true;

        shellAliases = import ../../base/shells/aliases.nix;

        profileExtra = lib.mkAfter ''
          if [ -f "${config.xdg.dataHome}/bash/profile" ]; then
            source "${config.xdg.dataHome}/bash/profile"
          fi
        '';

        bashrcExtra = lib.mkAfter ''
          if [ -f "${config.xdg.dataHome}/bash/bashrc" ]; then
            source "${config.xdg.dataHome}/bash/bashrc"
          fi
        '';
      };
    }

    (lib.mkIf config.my.home.base.shells.wsl {
      home.packages = with pkgs; [
        iproute2
        socat
      ];

      programs.bash.profileExtra = ''
        source "${config.xdg.dataHome}/bash/wsl2-ssh-pageant.sh"
      '';

      xdg.dataFile."bash/wsl2-ssh-pageant.sh".source =
        self.configDir + "/.config/shell/wsl2-ssh-pageant.sh";
    })
  ]);
}
