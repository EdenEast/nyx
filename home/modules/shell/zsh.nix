{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.modules.shell.zsh;

  pluginsDir = xdg.cacheHome."zsh/plugins";

  pluginModule = types.submodule ({ config, ... }: {
    options = {
      src = mkOption {
        type = types.path;
        description = ''
          Path to the plugin folder. Will be added to
          <envar>fpath</envar> and <envar>PATH</envar>.
        '';
      };

      name = mkOption {
        type = types.str;
        description = ''
          The name of the plugin.
          Don't forget to add <option>file</option>
          if the script name does not follow convention.
        '';
      };

      file = mkOption {
        type = types.str;
        description = "The plugin script to source.";
      };
    };

    config.file = mkDefault "${config.name}.plugin.zsh";
  });

in
{
  options.nyx.modules.shell.zsh = {
    enable = mkEnableOption "zsh configuration";

    enableCompletion = mkOption {
      type = types.bool;
      default = true;
      description = "Enable zsh completion";
    };

    enableAutosuggestions = mkOption {
      type = types.bool;
      default = true;
      description = "Enable zsh autosuggestions";
    };

    enableSyntaxHighlighting = mkOption {
      type = types.bool;
      default = true;
      description = "Enable zsh syntax highlighting";
    };

    plugins = mkOption {
      type = types.listOf pluginModule;
      default = [ ];
      description = "Plugins to install and source";
      example = liternalExample ''
        [
          {
            name = zsh-autosuggestions.plugin.zsh;
            src = pkgs.fetchFromGitHub {
              owner = "zsh-users";
              repo = "zsh-autosuggestions";
              rev = "v0.4.0";
              sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
            };
          }
          {
            name = "enhancd";
            file = "init.sh";
            src = pkgs.fetchFromGitHub {
              owner = "b4b4r07";
              repo = "enhancd";
              rev = "v2.2.1";
              sha256 = "0iqa9j09fwm6nj5rpip87x3hnvbbz9w9ajgm6wkrd5fls8fn8i5g";
            };
          }
        ]
      '';
    };

    envExtra = mkOption {
      type = types.lines;
      default = "";
      description =
        "Extra commands that should be added to <filename>.zshenv</filename>.";
    };

    profileExtra = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Extra commands that should be run when initializing a login
        shell.
      '';
    };

    initExtra = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Extra commands that should be run when initializing an
        interactive shell.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = with pkgs;
        [ zsh ] ++ optional cfg.enableCompletion nix-zsh-completions;
    }

    {
      home.file.".zshenv".source = ../../../config/.zshenv;
      xdg.configFile."zsh".source = ../../../config/.config/zsh;
    }

    {
      xdg.dataFile."zsh/nyx_zshrc".text = ''
        ${cfg.initExtra}

        ${concatStrings (map (plugin: ''
          if [ -f "$HOME/${pluginsDir}/${plugin.name}/${plugin.file}"  ]; then
            source "$HOME/${pluginsDir}/${plugin.name}/${plugin.file}"
          fi
        '') cfg.plugins)}

        ${optionalString cfg.enableAutosuggestions
        "source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"}

        ${optionalString cfg.enableSyntaxHighlighting
        "source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"}
      '';
    }

    (mkIf (cfg.profileExtra != "") {
      xdg.dataFile."zsh/nyx_zprofile".text = cfg.profileExtra;
    })

    (mkIf (cfg.envExtra != "") {
      xdg.dataFile."zsh/nyx_zshenv".text = cfg.envExtra;
    })

    (mkIf (cfg.plugins != [ ]) {
      nyx.modules.shell.zsh.enableCompletion = mkDefault true;

      home.file = foldl' (a: b: a // b) { }
        (map (plugin: { "${pluginsDir}/${plugin.name}".source = plugin.src; })
          cfg.plugins);
    })
  ]);
}

