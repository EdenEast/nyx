{
  config,
  lib,
  self,
  ...
}: let
  inherit (config.my.nixos) server;
in {
  imports = self.lib.fs.scanPaths ./.;

  options.my.nixos = {
    server = {
      domain = lib.mkOption {
        description = "Base domain name to be used to access the homelab services via Caddy reverse proxy";
        type = lib.types.str;
        default = "";
      };

      user = lib.mkOption {
        default = "share";
        type = lib.types.str;
        description = ''
          User to run the homelab services as
        '';
      };

      group = lib.mkOption {
        default = "share";
        type = lib.types.str;
        description = ''
          Group to run the homelab services as
        '';
      };
    };

    FLAKE = lib.mkOption {
      type = lib.types.str;
      default = "github:edeneast/nyx";
      description = "Default flake URL for this NixOS configuration.";
    };
  };

  config = lib.mkIf (config.my.nixos.server.domain != "") {
    users = {
      groups.${server.group} = {
        gid = 993;
      };
      users.${server.user} = {
        uid = 994;
        isSystemUser = true;
        inherit (server) group;
      };
    };
  };
}
