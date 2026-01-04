{
  config,
  lib,
  self,
  ...
}: let
  dataFilePath = path:
    lib.strings.concatStringsSep "/" [
      config.home.homeDirectory
      config.xdg.dataFile."${path}".target
    ];
in {
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

        profileExtra = lib.mkAfter ''
          source "${dataFilePath "zsh/zprofile"}"
        '';

        loginExtra = lib.mkAfter ''
          source "${dataFilePath "zsh/zlogin"}"
        '';

        initContent = lib.mkAfter ''
          source "${dataFilePath "zsh/zshrc"}"
        '';
      };

      # Required to be defined to be callable but disabling so file does not get generated
      xdg.dataFile = {
        "zsh/zprofile".enable = false;
        "zsh/zlogin".enable = false;
        "zsh/zshrc".enable = false;
      };
    }

    (lib.mkIf config.myHome.base.shells.wsl {
      programs.zsh.profileExtra = ''
        source "${dataFilePath "zsh/wsl2-ssh-pageant.sh"}"
      '';

      xdg.dataFile."zsh/wsl2-ssh-pageant.sh".source =
        self.configDir + "/.config/shell/wsl2-ssh-pageant.sh";
    })
  ]);
}
