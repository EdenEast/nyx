{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.my.home.programs.pi;
in {
  options.my.home.programs.pi = {
    enable = lib.mkEnableOption "pi coding agent harness";
    useBun = lib.mkOption {
      description = "Build with Bun instead of Node";
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = [
        ((pkgs.callPackage (inputs.llm-agents + /packages/pi/package.nix) {
            inherit (cfg) useBun;
            # llm-agents.nix defines this helper in its package scope, but it is
            # not exported. The Node build does not need the HOME workaround for
            # its version check, so an inert input is enough here.
            versionCheckHomeHook = pkgs.emptyFile;
          })
          .overrideAttrs (_old:
            lib.optionalAttrs cfg.useBun {
              # Pi 0.82.1's Bun binary no longer prints the package version from
              # `--version` or `--help`, so upstream's versionCheckHook fails
              # after an otherwise successful build.
              doInstallCheck = false;
            }))
      ];

      # sessionVariables = {
      #   PI_CODING_AGENT_DIR = "${config.xdg.configHome}/pi";
      # };
    };
  };
}
