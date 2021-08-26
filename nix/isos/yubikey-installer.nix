# https://github.com/drduh/YubiKey-Guide/tree/de29a9e#nixos

{ nixpkgs ? <nixpkgs>, system ? "x86_64-linux" }:

let
  config = { pkgs, ... }:
    with pkgs; {
      imports = [ <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix> ];

      boot.kernelPackages = linuxPackages_latest;

      services.pcscd.enable = true;
      services.udev.packages = [ yubikey-personalization ];

      environment.systemPackages = [
        # Gnupg packages
        gnupg
        pinentry-curses
        pinentry-qt
        paperkey
        wget

        # Editor and other useful pkgs
        neovim-unwrapped
      ];

      programs = {
        ssh.startAgent = false;
        gnupg.agent = {
          enable = true;
          enableSSHSupport = true;
        };
      };

      environment.shellInit = ''
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
        gpg --import /etc/nyx/public.key
      '';

      environment.etc = {
        "nyx/public.key".text = ''
          ${builtins.readFile ../../config/.gnupg/public.key}
        '';
      };
    };

  evalNixos = configuration: import <nixpkgs/nixos> {
    inherit system configuration;
  };

in
{
  iso = (evalNixos config).config.system.build.isoImage;
}
