{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  options.myHome.programs.neovim = {
    enable = lib.mkEnableOption "neovim editor";

    useNightly = lib.mkOption {
      description = "Use the nightly neovoim instead of latest stable";
      type = with lib.types; bool;
      default = false;
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = inputs.nvim-config.packages.${pkgs.stdenv.hostPlatform.system}.nightly;
    };
  };

  config = lib.mkIf config.myHome.programs.neovim.enable {
    # home.packages = [
    #   config.myHome.programs.neovim.package
    # ];
    home.packages = let
      nvim-packages = inputs.nvim-config.packages.${pkgs.stdenv.hostPlatform.system};
      package =
        if config.myHome.programs.neovim.useNightly
        then nvim-packages.nightly
        else nvim-packages.stable;
    in [package];
  };
}
