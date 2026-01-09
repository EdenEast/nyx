{
  config,
  lib,
  ...
}: {
  options.myHome.programs.nushell = {
    # FIXME: This option should not be necessary and should be able to use `config.programs.nushell.enable` instead however
    # this currently does not work as nushell is set as the user's default shell and enabled in the nixos module and the
    # value is not passed or reconized by the home-manager module. Meaning that if it is set in the nixos module it
    # would not be enabled in the home-manager module
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable nushell shell and related configuration.";
    };
  };

  config = lib.mkIf config.myHome.programs.nushell.enable {
    programs.nushell.enable = true;
  };
}
