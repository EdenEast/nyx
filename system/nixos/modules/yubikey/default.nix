{ config, inputs, lib, name, pkgs, ... }:

with lib;
let
  cfg = config.nyx.modules.yubikey;
in
{
  options.nyx.modules.yubikey = {
    enable = mkEnableOption "yubikey support";
    istty = mkEnableOption "Set pinentry to curses if no display";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      yubikey-personalization
      yubikey-manager
    ];

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = if cfg.istty then "curses" else "qt";
    };
    # environment.shellInit = ''
    #   export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
    # '';

    services = {
      # Required for gpg smartcard (yubikey) to work
      pcscd.enable = true;

      # Required for Yubikey device to work
      udev.packages = with pkgs; [ yubikey-personalization libu2f-host ];
    };
  };
}
