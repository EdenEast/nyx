{self, ...}: {
  home-manager.users.eden = {
    imports = builtins.attrValues self.homeModules;

    config = {
      home = {
        homeDirectory = "/home/eden";
        stateVersion = "25.11";
        username = "eden";
      };

      myHome = {
        base = {
          enable = true;
          shells.wsl = true;
        };

        programs = {
          git = {
            name = "EdenEast";
            email = "edenofest@gmail.com";
            key = "5A038CEFD458DB47A6135B3F8316DECECB1A3F10";
          };

          fish.enable = true;
          zsh.enable = true;

          # This is wsl so dont need applications
          ghostty.enable = false;
          zen.enable = false;
        };

        profiles.development.rust.enable = true;

        services = {
          gnupg = {
            enable = true;
            publicKeys = [
              {
                key = self.configDir + "/.gnupg/public.key";
              }
            ];
          };
        };
      };
    };
  };
}
