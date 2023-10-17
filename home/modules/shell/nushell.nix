{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.nyx.modules.shell.nushell;
  nu_scripts = "${pkgs.nu_scripts}/share/nu_scripts";
in
{
  options.nyx.modules.shell.nushell = {
    enable = mkEnableOption "neovim configuration";
    package = mkOption {
      description = "Package for nushell";
      type = with types; nullOr package;
      default = pkgs.nushell;
    };

    wsl = mkOption {
      type = types.bool;
      default = false;
      description = "Setup wsl gpg and ssh keys on shell startup";
    };
  };
  config = mkIf cfg.enable {
    programs.nushell = {
      enable = true;
      extraConfig = ''
        ${builtins.readFile ../../../config/.config/nushell/config.nu}

        # completions
        use ${nu_scripts}/custom-completions/cargo/cargo-completions.nu *
        use ${nu_scripts}/custom-completions/git/git-completions.nu *
        use ${nu_scripts}/custom-completions/just/just-completions.nu *
        use ${nu_scripts}/custom-completions/make/make-completions.nu *
        use ${nu_scripts}/custom-completions/nix/nix-completions.nu *

        # modules
        use ${nu_scripts}/modules/nix/nix.nu *
        use ${nu_scripts}/modules/filesystem/expand.nu *
      '';

      extraEnv = ''
        ${builtins.readFile ../../../config/.config/nushell/env.nu}
      '';

      extraLogin = ''
        ${pkgs.gpgssh-startup}
      '';
      # ${builtins.readFile ../../../config/.config/nushell/login.nu}

      shellAliases = {
        c = "cargo";
        e = "^$env.EDITOR";
        g = "git";
        j = "just";
        t = "tm";
        ll = "ls -al";
      };
    };

    xdg.configFile."nushell/scripts/rusty-paths.nu".source = "${nu_scripts}/hooks/rusty-paths/rusty-paths.nu";

    # home.packages = mkIf (cfg.package != null) [ cfg.package ];
    #
    # xdg.configFile."nushell" = {
    #   source = ../../../config/.config/nushell;
    #   executable = true;
    #   recursive = true;
    # };

  };
}
