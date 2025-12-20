{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.programs.git.enable = lib.mkEnableOption "git version control";

  config = lib.mkIf config.myHome.programs.git.enable {
    home = {
      packages = with pkgs;
        [
          git-open
          git-crypt
          git-graph
        ]
        ++ lib.optionals pkgs.stdenv.isLinux [pkgs.wl-clipboard];

      # sessionPath = ["${config.xdg.configHome}/git/bin"];
    };

    programs = {
      delta = {
        enable = true;
        enableGitIntegration = true;
      };

      git = {
        enable = true;
        lfs.enable = true;
      };

      lazygit.enable = true;
    };

    # xdg.configFile."git" = {
    #   source = ../../../../config/.config/git;
    #   executable = true;
    #   recursive = true;
    # };
  };
}
