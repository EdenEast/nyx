{
  config,
  lib,
  ...
}: {
  options.myNixOS.services.keybase.enable = lib.mkEnableOption "gdm display manager";

  config = lib.mkIf config.myNixOS.services.keybase.enable {
    services = {
      kbfs.enable = true;
      keybase.enable = true;
    };
  };
}
