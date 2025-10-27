{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.programs.zen.enable = lib.mkEnableOption "zen web browser";

  config = lib.mkIf config.myHome.programs.zen.enable {
    programs.zen-browser = {
      enable = true;
      # nativeMessagingHosts = lib.optionals pkgs.stdenv.isLinux [pkgs.bitwarden-desktop];
      package = lib.mkIf pkgs.stdenv.isDarwin (lib.mkForce null);

      profiles = {
        default = {
          containersForce = true;

          containers = {
            personal = {
              color = "purple";
              icon = "circle";
              id = 1;
              name = "Personal";
            };

            private = {
              color = "red";
              icon = "fingerprint";
              id = 2;
              name = "Private";
            };
          };

          extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
            dashlane
            web-clipper-obsidian
            consent-o-matic
            ublock-origin
          ];

          id = 0;

          # search = {
          #   inherit engines;
          #   default = "Kagi";
          #   force = true;
          #
          #   order = [
          #     "bing"
          #     "Brave"
          #     "ddg"
          #     "google"
          #     "Home Manager Options"
          #     "Kagi"
          #     "NixOS Wiki"
          #     "nixpkgs"
          #     "Noogle"
          #     "Wikipedia"
          #     "Wiktionary"
          #   ];
          # };

          settings = {
            "zen.welcome-screen.seen" = true;
            "zen.workspaces.continue-where-left-off" = true;
          };
        };
      };
    };
  };
}
