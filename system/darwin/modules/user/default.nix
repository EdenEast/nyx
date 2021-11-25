{ config, pkgs, self, ... }:

with self.lib;
let
  cfg = config.nyx.modules.user;
in
{
  options.nyx.modules.user = { };

  config = mkMerge [
    {
      users.users."${cfg.name}" = with cfg; {
        description = "James Simpson";
        shell = pkgs.zsh;
        home = "/Users/${cfg.name}";
      };
    }
  ];
}
