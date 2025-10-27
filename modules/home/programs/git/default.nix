{
  config,
  lib,
  ...
}: {
  options.myHome.programs.git.enable = lib.mkEnableOption "git version control";

  config = lib.mkIf config.myHome.programs.git.enable {
    programs = {
      delta = {
        enable = true;
        enableGitIntegration = true;
      };

      git = {
        enable = true;
        lfs.enable = true;

        settings = {
          color.ui = true;
          github.user = "edeneast";
          push.autoSetupRemote = true;

          user = {
            name = "EdenEast";
            email = "edenofest@gmail.com";
          };
        };
      };

      lazygit.enable = true;
    };
  };
}
