{
  config,
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
      server.domain = "edeneast.xyz";
      base = {
        enable = true;
        editor = inputs.nvim-config.packages.${pkgs.stdenv.hostPlatform.system}.stable;
      };

      services = {
        audiobookshelf.enable = true;
        caddy = {
          enable = true;
          credentials = config.age.secrets.cloudflareDnsCredentials.path;
        };
        cloudflared = {
          enable = true;
          credentialsFile = config.age.secrets.cloudflareTunnel.path;
          tunnelId = "78c6c286-8ea2-47e4-ada4-b55edd869b7a";
        };
        golink.enable = true;
        forgejo.enable = true;
        immich = {
          enable = true;
          mediaDir = "/data/photos/immich";
        };
        send.enable = true;
        searxng.enable = true;
        tailscale = {
          enable = true;
          exitnode = true;
        };
      };
    };

    users.eden = {
      password = "$6$nF.UDyrpHmh6M$yKCw56auQ7Dm1FfvmQg6y3Y59mWsoiHJyAYhqF9e8nKjfeKwUoFocwHhogKUTq.A3hVe9S.smv7u1NLV/yPTd0";
      enable = true;
    };
  };
}
