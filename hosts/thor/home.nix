{
  self,
  pkgs,
  ...
}: {
  home-manager.users.eden = {
    imports = builtins.attrValues self.homeModules;

    home = {
      username = "eden";
      homeDirectory = "/home/eden";
      stateVersion = "26.05";

      # Agent CLIs release faster than nixpkgs. npm owns these executables in
      # ~/.local, while Nix continues to provide their pinned Node runtime.
      packages = with pkgs; [
        agent-tools-update
        nodejs_24
      ];
      sessionPath = ["$HOME/.local/bin"];
      sessionVariables.NPM_CONFIG_PREFIX = "$HOME/.local";
    };

    my.home = {
      base.enable = true;
      programs = {
        fish.enable = true;
        git = {
          enable = true;
          name = "EdenEast";
          email = "edenofest@gmail.com";
        };
      };
      profiles.development = {
        node.enable = true;
        python.enable = true;
        rust.enable = true;
      };
    };
  };
}
