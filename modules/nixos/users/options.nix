{
  lib,
  self,
  ...
}: {
  options.my.users = let
    mkUser = user: {
      enable = lib.mkEnableOption "${user}.";

      password = lib.mkOption {
        default = null;
        description = "Hashed password for ${user}.";
        type = lib.types.nullOr lib.types.str;
      };
    };
  in
    {
      defaultGroups = lib.mkOption {
        description = "Default groups for desktop users.";
        default = [
          "cdrom"
          "dialout"
          "docker"
          "libvirtd"
          "lp"
          "networkmanager"
          "plugdev"
          "scanner"
          "transmission"
          "video"
          "wheel"
        ];
      };

      root.enable = lib.mkEnableOption "root user configuration." // {default = true;};
    }
    // self.lib.fs.importMapAttrs ./users {} (name: _: mkUser name);
}
