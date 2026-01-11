{
  config,
  lib,
  ...
}: {
  options.my.nixos.services.keybase.enable = lib.mkEnableOption "gdm display manager";

  config = lib.mkIf config.my.nixos.services.keybase.enable {
    services = {
      kbfs.enable = true;
      keybase.enable = true;
    };
  };
}
