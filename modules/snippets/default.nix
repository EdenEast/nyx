{self, ...}: {
  imports = self.lib.fs.scanPaths ./.;
}
