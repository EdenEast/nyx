{
  config,
  lib,
  self,
  ...
}: let
  cfg = config.myHome.programs.zsh;
in {
  # options.myHome.programs.zsh.enable = lib.mkEnableOption "zsh shell";

  options.myHome.programs.zsh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.programs.zsh.enable;
      description = "zsh shell";
    };

    wsl = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable wsl2-ssh-pageant to bridge between windows and wsl for yubikey support";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;

      enableCompletion = true;
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;

      shellAliases = import ../fish/aliases.nix;

      profileExtra = lib.mkIf cfg.wsl ''
        source "${config.home.homeDirectory}/${config.xdg.dataFile."zsh/wsl2-ssh-pageant.sh".target}"
      '';
    };

    xdg.dataFile."zsh/wsl2-ssh-pageant.sh" = {
      enable = cfg.wsl;
      source = self.configDir + "/.config/shell/wsl2-ssh-pageant.sh";
    };
  };
}
