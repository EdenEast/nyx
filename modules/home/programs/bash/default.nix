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
  options.myHome.programs.bash = {
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

  config = lib.mkIf config.myHome.programs.bash.enable (lib.mkMerge [
    {
      programs.bash = {
        enable = true;

        enableCompletion = true;

        shellAliases = import ../../base/shells/aliases.nix;

        # profileExtra = lib.mkAfter ''
        #   source "${dataFilePath "bash/profile"}"
        # '';
        #
        # loginExtra = lib.mkAfter ''
        #   source "${dataFilePath "bash/login"}"
        # '';
        #
        # initContent = lib.mkAfter ''
        #   source "${dataFilePath "bash/bashrc"}"
        # '';
      };

      # Required to be defined to be callable but disabling so file does not get generated
      xdg.dataFile."bash/profile".enable = false;
      xdg.dataFile."bash/login".enable = false;
      xdg.dataFile."bash/bashrc".enable = false;
    }

    (lib.mkIf config.myHome.base.shells.wsl {
      programs.bash.profileExtra = ''
        source "${dataFilePath "bash/wsl2-ssh-pageant.sh"}"
      '';

      xdg.dataFile."bash/wsl2-ssh-pageant.sh".source =
        self.configDir + "/.config/shell/wsl2-ssh-pageant.sh";
    })
  ]);
}
# {
#   config,
#   lib,
#   self,
#   ...
# }: let
#   dataFilePath = path:
#     lib.strings.concatStringsSep "/" [
#       config.home.homeDirectory
#       config.xdg.dataFile."${path}".target
#     ];
# in {
#   config = lib.mkIf config.programs.bash.enable (lib.mkMerge [
#     {
#       programs.bash = {
#         enableCompletion = true;
#
#         shellAliases = import ../../base/shells/aliases.nix;
#
#         # profileExtra = lib.mkAfter ''
#         #   source "${dataFilePath "bash/profile"}"
#         # '';
#
#         # loginExtra = lib.mkAfter ''
#         #   source "${dataFilePath "bash/login"}"
#         # '';
#
#         # initContent = lib.mkAfter ''
#         #   source "${dataFilePath "bash/bashrc"}"
#         # '';
#       };
#
#       # Required to be defined to be callable but disabling so file does not get generated
#       xdg.dataFile = {
#         "bash/profile".enable = false;
#         "bash/login".enable = false;
#         "bash/bashrc".enable = false;
#       };
#     }
#
#     (lib.mkIf config.myHome.base.shells.wsl {
#       programs.bash.profileExtra = ''
#         source "${config.home.homeDirectory}/${config.xdg.dataFile."bash/wsl2-ssh-pageant.sh".target}"
#       '';
#       xdg.dataFile."bash/wsl2-ssh-pageant.sh".source = self.configDir + "/.config/shell/wsl2-ssh-pageant.sh";
#     })
#   ]);
# }

