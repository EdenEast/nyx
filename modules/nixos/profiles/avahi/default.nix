{
  config,
  lib,
  ...
}: {
  options.my.nixos.services.avahi.enable = lib.mkEnableOption "avahi networking";

  config = lib.mkIf config.my.nixos.services.avahi.enable {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;

      publish = {
        enable = true;
        addresses = true;
        userServices = true;
        workstation = true;
      };
    };
  };
}
