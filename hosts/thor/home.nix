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

    # Keep both agents local to Thor. Pinentry prompts in the SSH terminal.
    services = {
      gpg-agent = {
        enable = true;
        enableSshSupport = false;
        enableScDaemon = false;
        pinentry.package = pkgs.pinentry-curses;
      };
      ssh-agent.enable = true;
    };

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings."*" = {
        IdentityFile = "~/.ssh/id_ed25519";
        AddKeysToAgent = "yes";
      };
    };

    my.home = {
      base.enable = true;
      services.gnupg.enable = true;
      programs = {
        fish.enable = true;
        git = {
          enable = true;
          name = "EdenEast";
          email = "edenofest@gmail.com";
          key = "2EBD301FB16DCF89277EF87C42B8084E708E8AA6";
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
