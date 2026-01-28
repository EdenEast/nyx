{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (lib) mkOption types;

  cfg = config.my.home.programs.git;

  gitIniType = with types; let
    primitiveType = nullOr (either str (either bool int));
    multipleType = either primitiveType (listOf primitiveType);
    sectionType = attrsOf multipleType;
    supersectionType = attrsOf (either multipleType sectionType);
  in
    attrsOf supersectionType;

  git-wt = pkgs.writeShellScriptBin "git-wt" (builtins.readFile ./git-wt);

  git-wrapper = pkgs.writeShellScriptBin "git" ''
    function main() {

      if [ $# -eq 0 ]; then
        ${lib.getExe pkgs.git} status -s
        return
      fi

    ${
      if cfg.wsl
      then
        # bash
        ''
          # List of commands to check
          local wsl_commands=("clone" "commit" "fetch" "push" "pull" "remote")
          for cmd in ${"\${wsl_commands[@]}"}; do
            if [ "$1" = "$cmd" ]; then
              git.exe "$@"
              return
            fi
          done
        ''
      else ""
    }

      ${lib.getExe pkgs.git} "$@"
    }

    main "$@"
  '';
in {
  options.my.home.programs.git = {
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

    wsl = mkOption {
      type = types.bool;
      default = false;
      description = "Update wrapper script with wsl support";
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

  config = lib.mkIf config.my.home.programs.git.enable {
    home = {
      packages = with pkgs; [
        git-open
        git-crypt
        git-graph
        git-wt
      ];

      sessionPath = ["${config.xdg.configHome}/git/bin"];

      shellAliases = {
        gg = lib.mkIf cfg.wsl "git.exe";
      };
    };

    programs = {
      delta = {
        enable = true;
        enableGitIntegration = true;
      };

      git = {
        enable = true;
        package = git-wrapper;
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

    my.home.programs.git.iniContent =
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
