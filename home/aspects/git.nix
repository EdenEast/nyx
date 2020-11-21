{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.aspects.git;

  signModule = types.submodule {
    options = {
      key = mkOption {
        type = types.str;
        description = "The default GPG signing key fingerprint.";
      };

      signByDefault = mkOption {
        type = types.bool;
        default = false;
        description = "Whether commits should be signed by default.";
      };

      gpgPath = mkOption {
        type = types.str;
        default = "${pkgs.gnupg}/bin/gpg2";
        defaultText = "\${pkgs.gnupg}/bin/gpg2";
        description = "Path to GnuPG binary to use.";
      };
    };
  };
in
{
  options.nyx.aspects.git = {
    enable = mkEnableOption "git configuration";

    minimal = mkOption {
      type = types.bool;
      default = false;
      description = "Minimal install without extra packages";
    };

    userName = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Default user name to use.";
    };

    userEmail = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Default user email to use.";
    };

    signing = mkOption {
      type = types.nullOr signModule;
      default = null;
      description = "Options related to signing commits using GnuPG.";
    };
  };

  config = mkIf cfg.enable {
    home.sessionPath = [
      "${config.xdg.configHome}/git/bin"
    ];

    home.sessionVariables = {
      GIT_PAGER = if cfg.minimal then "less" else "delta --dark --theme TwoDark";
    };

    home.packages = with pkgs;
    let
      minimal = [ git ];

      extra = if !cfg.minimal then [
        git-lfs
        gitAndTools.delta
        gitAndTools.gh
        gitAndTools.git-crypt
        gitAndTools.git-open
        gitAndTools.grv
        gitAndTools.hub
        gitAndTools.tig
      ] else [];

      total = minimal ++ extra;
    in total;

    xdg.configFile."git".source = ../files/.config/git;
    xdg.dataFile."git/nyx-gen".text = let
      userSection = if (cfg.userName != null && cfg.userEmail != null) then ''
        [user]
        name = ${cfg.userName}
        email = ${cfg.userEmail}
      '' else "";

      signingSection = if (cfg.signing != null) then ''
        [user]
        signingKey = ${cfg.signing.key}

        [commit]
        gpgSign = ${cfg.signing.signByDefault}

        [gpg]
        program = ${cfg.signing.gpgPath}
      '' else "";

    in ''
      ${userSection}
      ${signingSection}
    '';
  };
}
