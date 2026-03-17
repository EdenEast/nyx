{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware.nix
    ./secrets.nix
  ];

  # Base system definitions
  networking.hostName = "thor";
  system.stateVersion = "25.11";

  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_US.UTF-8";

  my = {
    nixos = {
      base = {
        enable = true;
        editor = inputs.nvim-config.packages.${pkgs.stdenv.hostPlatform.system}.stable;
      };

      profiles = {
        keymap.enable = true;
      };

      services = {
        audiobookshelf = {
          enable = true;
          tailscale.enable = true;
        };
        tailscale.enable = true;
      };
    };

    users.eden = {
      password = "$6$nF.UDyrpHmh6M$yKCw56auQ7Dm1FfvmQg6y3Y59mWsoiHJyAYhqF9e8nKjfeKwUoFocwHhogKUTq.A3hVe9S.smv7u1NLV/yPTd0";
      enable = true;
    };
  };
}
