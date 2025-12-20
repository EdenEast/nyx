{
  config,
  lib,
  ...
}: {
  options.myNixOS.profiles.audio.enable = lib.mkEnableOption "audio support";

  config = lib.mkIf config.myNixOS.profiles.audio.enable {
    security.rtkit.enable = true;

    services = {
      pipewire = {
        enable = true;

        alsa = {
          enable = true;
          support32Bit = true;
        };

        pulse.enable = true;
      };

      pulseaudio.support32Bit = true;
    };
  };
}
