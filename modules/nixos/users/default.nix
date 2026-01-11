{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports =
    [
      ./options.nix
    ]
    ++ self.lib.importsAllNixFiles ./users;

  config = lib.mkIf (config.my.users.root.enable or config.my.users.eden.enable) {
    programs.fish.enable = true;

    users = {
      defaultUserShell = pkgs.fish;
      mutableUsers = false;
    };

    # # As fish is not posix compliant there is issues with this being the system shell
    # # https://nixos.wiki/wiki/Fish#Setting_fish_as_your_shell
    # programs.bash = {
    #   interactiveShellInit = ''
    #     if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
    #     then
    #       shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
    #       exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
    #     fi
    #   '';
    # };
  };
}
