{
  config,
  lib,
  self,
  user,
  ...
}:
with self.lib; let
  cfg = config.nyx.modules.docker;
in {
  options.nyx.modules.docker = {
    enable = mkEnableOption "docker support";
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;

    users.users."${config.nyx.modules.user.name}".extraGroups = ["docker"];
  };
}
