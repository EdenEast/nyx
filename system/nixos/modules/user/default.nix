{ config, lib, pkgs, self, user, ... }:

with self.lib;
let
  cfg = config.nyx.modules.user;

  isPasswdCompatible = str: !(hasInfix ":" str || hasInfix "\n" str);
  passwdEntry = type: lib.types.addCheck type isPasswdCompatible // {
    name = "passwdEntry ${type.name}";
    description = "${type.description}, not containing newlines or colons";
  };

  defaultHashedPassword = existsOrDefault "hashedPassword" user null;

  defaultExtraGroups = [
    "audio"
    "docker"
    "games"
    "locate"
    "networmanager"
    "wheel"
  ];
in
{
  options.nyx.modules.user = {
    extraGroups = mkOption {
      type = types.listOf types.str;
      default = defaultExtraGroups;
      description = "The user's auxiliary groups.";
    };

    hashedPassword = mkOption {
      type = with types; nullOr (passwdEntry str);
      default = defaultHashedPassword;
      description = ''
        Specifies the hashed password for the user.
      '';
    };
  };

  config = mkMerge [
    {
      users = {
        users."${cfg.name}" = with cfg; {
          inherit hashedPassword extraGroups;
          description = "James Simpson";
          isNormalUser = true;
          # `shell` attribute cannot be removed! If no value is present then there will be no shell
          # configured for the user and SSH will not allow logins!
          shell = pkgs.zsh;
          uid = 1000;
        };

        # Do not allow users to be added or modified except through Nix configuration.
        mutableUsers = false;
      };

      nix.settings.trusted-users = [ "${cfg.name}" ];
    }
  ];
}
