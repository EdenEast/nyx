{ config, lib, pkgs, ... }:

with lib;
with builtins;
let
  cfg = config.nyx.modules.shell.repo;

  quote = c: ''"${c}"'';

  nullOrEmpty = c: str: optional (c != null && c != [ ]) str;

  remoteToStr = r: ''
    [[remotes]]
    name = "${r.name}"
    url = "${r.url}"
  '';

  projectToStr = p: concatStringsSep "\n" ([ "name = ${p.name}" ]
    ++ nullOrEmpty p.path "path = ${quote p.path}"
    ++ nullOrEmpty p.clone "clone = ${quote p.clone}"
    ++ nullOrEmpty p.work "work = ${quote p.work}"
    ++ nullOrEmpty p.cli "cli = ${toString p.cli}"
    ++ nullOrEmpty p.tags "tags = [${concatStringsSep ", " (map (x: quote x) p.tags)}]"
    ++ [""]
    ++ (map remoteToStr p.remotes));

  tagToStr = t: concatStringsSep "\n" (["name = ${t.name}"]
    ++ nullOrEmpty t.path "path = ${quote t.path}"
    ++ nullOrEmpty t.clone "clone = ${quote t.clone}"
    ++ nullOrEmpty t.work "work = ${quote t.work}"
    ++ nullOrEmpty t.cli "cli = ${toString t.cli}"
    ++ nullOrEmpty t.priority "priority = ${toString t.priority}"
  );

  writeFiles = prefix: f: list:
    listToAttrs (map
      (p: {
        name = "${prefix}/${p.name}";
        value = { text = f p; };
      })
      list);

  remoteConfig = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        default = "origin";
        description = "Name of the additional remote";
      };

      url = mkOption {
        type = types.nonEmptyStr;
        default = "";
        description = "Url of the additional remote";
      };
    };
  };

  tagConfig = types.submodule {
    options = {
      name = mkOption {
        type = types.nonEmptyStr;
        default = "";
        description = "Name of tag";
      };

      path = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Path appended to project workspace";
      };

      clone = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Command to be executed after clone";
      };

      work = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Command to be executed after work command";
      };

      cli = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Use the command line or not";
      };

      priority = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = "The order in which tags are applied";
      };
    };
  };

  projectConfig = types.submodule {
    options = {
      name = mkOption {
        type = types.nonEmptyStr;
        default = "";
        description = "Name of project";
      };

      remotes = mkOption {
        type = types.nonEmptyListOf remoteConfig;
        default = [ ];
        description = "List of remotes";
      };

      tags = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "List of tags";
      };

      path = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Path appended to project workspace";
      };

      clone = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Command to be executed after clone";
      };

      work = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Command to be executed after work command";
      };

      cli = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Use the command line or not";
      };
    };
  };

in
{
  options.nyx.modules.shell.repo = {
    enable = mkEnableOption "repo configuration";

    projects = mkOption {
      type = with types; listOf projectConfig;
      default = [ ];
      description = "List of projects";
    };

    tags = mkOption {
      type = with types; listOf tagConfig;
      default = [ ];
      description = "List of tags";
    };

    root = mkOption {
      type = types.path;
      default = "${config.home.homeDirectory}/dev";
      defaultText = literalExpression "\"${config.home.homeDirectory}/dev\"";
      description = "Root folder of repo's workspace";
    };

    cli = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = "Use cli for interfacing with git globally";
    };

    defaultHost = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "The default host to use if a query is just `user/repo`";
    };

    defaultScheme = mkOption {
      type = types.enum [ "https" "git" "ssh" ];
      default = "ssh";
      description = "The default scheme type for the generated urls";
    };

    defaultSshUser = mkOption {
      type = types.str;
      default = "git";
      description = "The default ssh user when generating urls with ssh schema";
    };

    shell = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = [ ];
      description = "The shell that all external command line calls will use";
    };

    include = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "A list of tags that will be used to filter the list of repos. If a repo has a tag in the list it will pass the filter";
    };

    exclude = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "A list of tags that will be used to filter the list of repos. If a repo has a tag in the list it will fail the filter";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.repo ];

    # Write project and tag files defined in their respective config lists
    xdg.configFile =
      let
        projectFiles = writeFiles "repo/repository" projectToStr cfg.projects;
        tagFiles = writeFiles "repo/tag" tagToStr cfg.tags;
      in
      projectFiles // tagFiles // {
        "repo/config.toml".text = concatStringsSep "\n" (
          [ "root = ${toString cfg.root}" ]
          ++ nullOrEmpty cfg.cli "cli = ${toString cfg.cli}"
          ++ nullOrEmpty cfg.defaultHost "default_host = ${quote cfg.defaultHost}"
          ++ nullOrEmpty cfg.defaultScheme "default_scheme = ${quote cfg.defaultScheme}"
          ++ nullOrEmpty cfg.defaultSshUser "default_ssh_user = ${quote cfg.defaultSshUser}"
          ++ nullOrEmpty cfg.shell "shell = [${concatStringsSep ", " (map (x: quote x) cfg.shell)}]"
          ++ nullOrEmpty cfg.include "include = [${concatStringsSep ", " (map (x: quote x) cfg.include)}]"
          ++ nullOrEmpty cfg.exclude "exclude = [${concatStringsSep ", " (map (x: quote x) cfg.exclude)}]"
        );
      };
  };
}

