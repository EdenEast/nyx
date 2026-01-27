{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  options.my.home.programs.neovim = {
    enable = lib.mkEnableOption "neovim editor";

    useNightly = lib.mkOption {
      description = "Use the nightly neovoim instead of latest stable";
      type = with lib.types; bool;
      default = false;
    };
  };

  config = lib.mkIf config.my.home.programs.neovim.enable {
    home = {
      packages = let
        nvim-packages = inputs.nvim-config.packages.${pkgs.stdenv.hostPlatform.system};
        package =
          if config.my.home.programs.neovim.useNightly
          then nvim-packages.nightly
          else nvim-packages.stable;
      in [package];

      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    };
  };
}
