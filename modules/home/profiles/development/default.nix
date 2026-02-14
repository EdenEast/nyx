{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = self.lib.fs.scanPaths ./.;

  options.my.home.profiles.development.enable = lib.mkEnableOption "base development";

  config = lib.mkIf config.my.home.profiles.development.enable {
    home.packages = with pkgs; [
      # Benchmarking.
      hyperfine
      # Just a command runner
      just
      # Codebase statistics.
      tokei
      # command-line JSON processor
      jq
      # TUI playground to experiment with jq
      jqp
    ];
  };
}
