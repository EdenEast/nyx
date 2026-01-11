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
    enable = lib.mkEnableOption "gdm display manager";
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

    # ensure that the ssh agent does not start and is used by gpgconf
    programs.ssh.startAgent = false;

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
