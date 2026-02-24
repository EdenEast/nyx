{
  config,
  lib,
  ...
}: {
  options.my.nixos.services.openssh = {
    enable = lib.mkEnableOption "openssh server";
  };

  config = lib.mkIf config.my.nixos.services.openssh.enable {
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings.PasswordAuthentication = false;
    };
  };
}
