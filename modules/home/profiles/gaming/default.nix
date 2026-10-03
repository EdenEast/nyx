{
  lib,
  self,
  ...
}: {
  imports = self.lib.fs.scanPaths ./.;

  options.my.home.profiles.gaming.enable = lib.mkEnableOption "base gaming profile";
}
