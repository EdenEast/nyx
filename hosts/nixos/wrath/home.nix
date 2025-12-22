{self, ...}: {
  home-manager.users.eden = {
    imports = [
      self.homeModules.default
    ];
    config = {
      home = {
        homeDirectory = "/home/eden";
        stateVersion = "25.11";
        username = "eden";
      };

      myHome = {
        base.enable = true;

        programs = {
          git = {
            name = "EdenEast";
            email = "edenofest@gmail.com";
            key = "5A038CEFD458DB47A6135B3F8316DECECB1A3F10";
          };
          obsidian.enable = true;
          zen.enable = true;
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
