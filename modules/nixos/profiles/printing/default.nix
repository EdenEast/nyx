{
  config,
  lib,
  ...
}: {
  options.my.nixos.profiles.printing.enable = lib.mkEnableOption "printing support";

  config = lib.mkIf config.my.nixos.profiles.printing.enable {
    programs.system-config-printer.enable = true;

    services = {
      printing.enable = true;
      system-config-printer.enable = true;
    };

    my.nixos.services.avahi.enable = true;
  };
}
