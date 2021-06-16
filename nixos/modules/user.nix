{ config, inputs, lib, name, pkgs, ... }:

with lib;
let
  cfg = config.nyx.modules.user;
in
{
  options.nyx.modules.user.enable = mkEnableOption "user account";

  imports = [ inputs.home-manager.nixosModules.home-manager ];

  config = mkIf cfg.enable {
    home-manager = mkIf (hasAttr name inputs.self.internal.hostConfigurations) {
      useUserPackages = true;
      useGlobalPkgs = true;
      users.eden = inputs.self.internal.hostConfigurations."${name}";
    };

    nix = {
      trustedUsers = [ "eden" ];
    };

    # Required to use `zsh` as a shell on a remote host, else no SSH.
    # programs.zsh.enable = true;

    users = {
      users.eden = {
        description = "James Simpson";
        extraGroups = [
          "audio"
          "docker"
          "games"
          "locate"
          "networmanager"
          "wheel"
        ];
        isNormalUser = true;
        initialPassword = "changeme";
        # `shell` attribute cannot be removed! If no value is present then there will be no shell
        # configured for the user and SSH will not allow logins!
        # shell = zsh;
        uid = 1000;
      };

      # Do not allow users to be added or modified except through Nix configuration.
      mutableUsers = false;
    };
  };
}
