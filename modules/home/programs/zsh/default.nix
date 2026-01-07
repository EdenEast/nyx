{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  options.myHome.programs.zsh = {
    # FIXME: This option should not be necessary and should be able to use `config.programs.zsh.enable` instead however
    # this currently does not work as zsh is set as the user's default shell and enabled in the nixos module and the
    # value is not passed or reconized by the home-manager module. Meaning that if it is set in the nixos module it
    # would not be enabled in the home-manager module
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable zsh shell and related configuration.";
    };
  };

  config = lib.mkIf config.myHome.programs.zsh.enable (lib.mkMerge [
    {
      programs.zsh = {
        enable = true;

        enableCompletion = true;
        syntaxHighlighting.enable = true;
        autosuggestion.enable = true;

        shellAliases = import ../../base/shells/aliases.nix;

        # make sure the dot files conform to
        dotDir = "${config.xdg.configHome}/zsh";

        profileExtra = lib.mkAfter ''
          if [ -f "${config.xdg.dataHome}/zsh/zprofile" ]; then
            source "${config.xdg.dataHome}/zsh/zprofile"
          fi
        '';

        loginExtra = lib.mkAfter ''
          if [ -f "${config.xdg.dataHome}/zsh/zlogin" ]; then
            source "${config.xdg.dataHome}/zsh/zlogin"
          fi
        '';

        initContent = lib.mkAfter ''
          if [ -f "${config.xdg.dataHome}/zsh/zshrc" ]; then
            source "${config.xdg.dataHome}/zsh/zshrc"
          fi
        '';
      };
    }

    (lib.mkIf config.myHome.base.shells.wsl {
      home.packages = with pkgs; [
        iproute2
        socat
      ];

      programs.zsh.profileExtra = lib.mkAfter ''
        source "${config.xdg.dataHome}/zsh/wsl2-ssh-pageant.sh"
      '';

      xdg.dataFile."zsh/wsl2-ssh-pageant.sh".source =
        self.configDir + "/.config/shell/wsl2-ssh-pageant.sh";
    })
  ]);
}
