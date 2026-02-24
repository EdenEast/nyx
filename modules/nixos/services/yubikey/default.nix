{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.programs.gnupg) package;
  cfg = config.my.nixos.services.yubikey;
in {
  options.my.nixos.services.yubikey = {
    enable = lib.mkEnableOption "Yubikey support for gpg and ssh-agent";
    pinentry = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = pkgs.pinentry-tty;
    };
  };

  config = lib.mkIf config.my.nixos.services.yubikey.enable {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = cfg.pinentry;
    };

    environment = {
      shellInit = ''
        export GPG_TTY="$(tty)"
        gpg-connect-agent /bye
        export SSH_AUTH_SOCK=$(${package}/bin/gpgconf --list-dirs agent-ssh-socket) # marker
      '';
      variables = {
        SSH_AUTH_SOCK = "$(${package}/bin/gpgconf --list-dirs agent-ssh-socket)";
      };
    };

    services = {
      # Required for gpg smartcard (yubikey) to work
      pcscd.enable = true;

      # Required for Yubikey device to work
      udev.packages = with pkgs; [
        libu2f-host
        yubikey-personalization
      ];
    };
  };
}
