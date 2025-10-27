{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  cfg = config.myHome.programs.neovim;
in {
  options.myHome.programs.neovim = {
    enable = lib.mkEnableOption "git version control";

    package = lib.mkOption {
      type = lib.types.package;
      default = self.inputs.nvim-config.packages.${pkgs.stdenv.hostPlatform.system}.nightly;
    };
  };

  config = lib.mkIf config.myHome.programs.neovim.enable {
    home.packages = [
      cfg.package
    ];
  };
}
