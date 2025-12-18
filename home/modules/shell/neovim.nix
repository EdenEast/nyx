{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.nyx.modules.shell.neovim;
in {
  options.nyx.modules.shell.neovim = {
    enable = mkEnableOption "neovim configuration";

    useNightly = mkOption {
      description = "Use the nightly neovoim instead of latest stable";
      type = with types; bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = let
      nvim-packages = inputs.nvim-config.packages.${pkgs.stdenv.hostPlatform.system};
      package =
        if cfg.useNightly
        then nvim-packages.nightly
        else nvim-packages.stable;
    in [package];
  };
}
