{ config, inputs, lib, name, pkgs, self, system, user, ... }:

with lib;
let
  cfg = config.nyx.modules.systemUser;

  isPasswdCompatible = str: !(hasInfix ":" str || hasInfix "\n" str);
  passwdEntry = type: lib.types.addCheck type isPasswdCompatible // {
    name = "passwdEntry ${type.name}";
    description = "${type.description}, not containing newlines or colons";
  };

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
  options.nyx.modules.systemUser = {
    name = mkOption {
      type = types.str;
      default = null;
      description = "User's name";
    };

    extraGroups = mkOption {
      type = types.listOf types.str;
      default = defaultExtraGroups;
      description = "The user's auxiliary groups.";
    };

    hashedPassword = mkOption {
      type = with types; nullOr (passwdEntry str);
      default = null;
      description = ''
        Specifies the hashed password for the user.
      '';
    };

    home = mkOption {
      type = with types; nullOr types.path;
      default = null;
      description = "Path of home manager home file";
    };
  };

  config = mkMerge [
    {
      users = {
        users."${name}" = with cfg; {
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

      nix.trustedUsers = [ "${name}" ];
    }
    (
      mkIf (cfg.home != null) {
        home-manager = {
          # useUserPackages = true;
          useGlobalPkgs = true;
          extraSpecialArgs = { inherit inputs name self system user; };
          users."${name}" = self.lib.mkUserHome { inherit system; config = cfg.home; };
        };
      }
    )
  ];
}
