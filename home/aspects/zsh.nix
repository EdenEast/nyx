{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.aspects.zsh;
in {
  options.nyx.aspects.zsh = {
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

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ zsh ] ++ optional cfg.enableCompletion nix-zsh-completions;
    home.file.".zshenv".source = ../files/.zshenv;
    xdg.configFile."zsh".source = ../files/.config/zsh;

    xdg.dataFile."zsh/zshrc".text = ''
      ${cfg.initExtra}
    '';
    xdg.dataFile."zsh/zprofile".text = ''
      ${cfg.profileExtra}
    '';
    xdg.dataFile."zsh/zshenv".text = ''
      ${cfg.profileExtra}
    '';
  };
}

