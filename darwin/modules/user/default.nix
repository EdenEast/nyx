{ config, pkgs, self, system, user, ... }:

with self.lib;
let
  cfg = config.nyx.modules.user;
  defaultName = existsOrDefault "name" user null;
in
{
  options.nyx.modules.user = {
    name = mkOption {
      type = types.str;
      default = defaultName;
      description = "User's name";
    };

    home = mkOption {
      type = with types; nullOr types.path;
      default = null;
      description = "Path of home manager home file";
    };
  };

  config = mkMerge [
    {
      users.users."${cfg.name}" = with cfg; {
        description = "James Simpson";
        shell = pkgs.zsh;
        home = "/Users/${cfg.name}";
      };
    }
    (
      mkIf (cfg.home != null) {
        home-manager.users."${cfg.name}" = mkUserHome { inherit system; config = cfg.home; };
      }
    )
  ];
}
