{ config, lib, pkgs, ... }:

with lib;
with builtins;
let
  cfg = config.nyx.modules.shell.repo;

  quote = c: ''"${c}"'';

  nullOrEmpty = c: str: optional (c != null && c != [ ]) str;

  strFromBool = b: if b then "true" else "false";

  remoteToStr = r:
    let
      name = if r ? name then r.name else "origin";
      url = if r ? url then r.url else r;
    in
    ''
      [[remotes]]
      name = "${name}"
      url = "${url}"
    '';

  projectToStr = p: concatStringsSep "\n" ([ "name = ${quote p.name}" ]
    ++ nullOrEmpty p.path "path = ${quote p.path}"
    ++ nullOrEmpty p.clone "clone = ${quote p.clone}"
    ++ nullOrEmpty p.work "work = ${quote p.work}"
    ++ nullOrEmpty p.cli "cli = ${strFromBool p.cli}"
    ++ nullOrEmpty p.tags "tags = [${concatStringsSep ", " (map (x: quote x) p.tags)}]"
    ++ [ "" ]
    ++ (if isList p.remote then map remoteToStr p.remote else [ (remoteToStr p.remote) ]));

  tagToStr = t: concatStringsSep "\n" ([ "name = ${quote t.name}" ]
    ++ nullOrEmpty t.path "path = ${quote t.path}"
    ++ nullOrEmpty t.clone "clone = ${quote t.clone}"
    ++ nullOrEmpty t.work "work = ${quote t.work}"
    ++ nullOrEmpty t.cli "cli = ${strFromBool t.cli}"
    ++ nullOrEmpty t.priority "priority = ${toString t.priority}"
  );

  writeFiles = prefix: f: set:
    mapAttrs'
      (name: value:
        let
          nameValue = if value.name != null then value.name else name;
        in
        nameValuePair ("${prefix}/${name}.toml") ({
          text = f ((filterAttrs (n: v: n != "name") value) // { name = nameValue; });
        })
      )
      set;

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
        type = types.nullOr types.str;
        default = null;
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
        type = types.nullOr types.str;
        default = null;
        description = "Name of project";
      };

      remote = mkOption {
        type = with types; either (nonEmptyListOf remoteConfig) str;
        default = [ ];
        description = "Either a list of remotes or a string for 'origin' url";
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
      type = with types; attrsOf projectConfig;
      default = { };
      description = "Set of projects";
    };

    tags = mkOption {
      type = with types; attrsOf tagConfig;
      default = { };
      description = "Set of tags";
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
          [ "root = ${quote (toString cfg.root)}" ]
          ++ nullOrEmpty cfg.cli "cli = ${strFromBool cfg.cli}"
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

