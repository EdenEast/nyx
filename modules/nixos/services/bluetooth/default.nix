{
  config,
  lib,
  ...
}: {
  options.myNixOS.services.bluetooth = {
    enable = lib.mkEnableOption "yubikey support";
  };

  config = lib.mkIf config.myNixOS.services.bluetooth.enable {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}
