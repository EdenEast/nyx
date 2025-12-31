{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (lib) mkOption types;

  cfg = config.myHome.programs.git;

  gitIniType = with types; let
    primitiveType = nullOr (either str (either bool int));
    multipleType = either primitiveType (listOf primitiveType);
    sectionType = attrsOf multipleType;
    supersectionType = attrsOf (either multipleType sectionType);
  in
    attrsOf supersectionType;

  git-wt = pkgs.writeShellScriptBin "git-wt" (builtins.readFile ./git-wt);
in {
  options.myHome.programs.git = {
    enable = lib.mkEnableOption "git version control";

    name = mkOption {
      type = types.str;
      default = "EdenEast";
      description = "Default user name to use.";
    };

    email = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Default user email to use.";
    };

    key = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "The default GPG signing key fingerprint.";
    };

    # signing = mkOption {
    #   type = signModule;
    #   default = {};
    #   description = "Options related to signing commits using GnuPG.";
    # };

    iniContent = mkOption {
      type = gitIniType;
      internal = true;
    };
  };

  config = lib.mkIf config.myHome.programs.git.enable {
    home = {
      packages = with pkgs; [
        git-open
        git-crypt
        git-graph
        git-wt
      ];

      sessionPath = ["${config.xdg.configHome}/git/bin"];
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

    xdg.configFile."git" = {
      source = self.configDir + "/.config/git";
      executable = true;
      recursive = true;
    };

    xdg.dataFile."git/nyx-gen".text = lib.generators.toGitINI (self.lib.pruneAttrs cfg.iniContent);

    myHome.programs.git.iniContent =
      {
        user = {
          inherit (cfg) email name;
          signingKey = cfg.key;
        };
        gpg.program = lib.getExe pkgs.gnupg;
      }
      // lib.optionalAttrs (cfg.key != null) {
        commit.gpgSign = true;
        tag.gpgSign = true;
      };
  };
}
