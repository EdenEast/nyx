{
  pkgs,
  self,
  ...
}: {
  # GUI applications such as T3 Code inherit the display-manager PATH rather
  # than Home Manager's shell PATH. Keep mutable agent CLIs visible to both.
  environment.localBinInPath = true;

  home-manager.users.eden = {
    imports = builtins.attrValues self.homeModules;

    config = {
      home = {
        homeDirectory = "/home/eden";
        stateVersion = "25.11";
        username = "eden";

        # Agent CLIs release faster than nixpkgs. npm owns these executables in
        # ~/.local, while Nix continues to provide their pinned Node runtime.
        packages = [
          pkgs.agent-tools-update
          pkgs.nodejs_24
        ];
        sessionPath = ["$HOME/.local/bin"];
        sessionVariables.NPM_CONFIG_PREFIX = "$HOME/.local";
      };

      my.home = {
        base.enable = true;

        programs = {
          fish.enable = true;
          nushell.enable = true;
          zsh.enable = true;

          git = {
            name = "EdenEast";
            email = "edenofest@gmail.com";
            key = "33FE803816CE6F0774145B13425E167F5B8FF416";
          };

          # Install these outside the Nix store so their upstream releases can
          # be updated without rebuilding the machine configuration.
          claude.enable = false;
          codex.enable = false;
          pi.enable = false;

          neovim.useNightly = true;
          discord.enable = true;
          spotify.enable = true;
          obsidian.enable = true;
          zen.enable = true;
        };

        profiles = {
          development.rust.enable = true;
          gaming.runescape.enable = true;
        };

        services = {
          gnupg = {
            enable = true;
            publicKeys = [
              {
                key = self.configDir + "/.gnupg/public.asc";
              }
            ];
          };
        };
      };
    };
  };
}
