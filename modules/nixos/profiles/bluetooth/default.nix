{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.nixos.profiles.bluetooth.enable = lib.mkEnableOption "bluetooth support";

  config = lib.mkIf config.my.nixos.profiles.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    services = {
      blueman.enable = true;
      pulseaudio = {
        package = pkgs.pulseaudioFull; # Use extra Bluetooth codecs like aptX

        extraConfig = ''
          load-module module-bluetooth-discover
          load-module module-bluetooth-policy
          load-module module-switch-on-connect
        '';
      };
    };
  };
}
