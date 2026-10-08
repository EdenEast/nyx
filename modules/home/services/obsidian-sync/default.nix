{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.home.services.obsidian-sync;
  ob = lib.getExe cfg.package;
  readyFile = "${config.xdg.stateHome}/obsidian-sync/${builtins.hashString "sha256" cfg.vaultPath}.ready";
  configure = pkgs.writeShellScript "obsidian-sync-configure" ''
    exec ${ob} sync-config \
      --path ${lib.escapeShellArg cfg.vaultPath} \
      --device-name ${lib.escapeShellArg cfg.deviceName} \
      --mode ${lib.escapeShellArg cfg.mode} \
      --configs ${lib.escapeShellArg (lib.concatStringsSep "," cfg.configs)} \
      --file-types ${lib.escapeShellArg (lib.concatStringsSep "," cfg.fileTypes)}
  '';
  setup = pkgs.writeShellApplication {
    name = "obsidian-sync-setup";
    runtimeInputs = [cfg.package pkgs.coreutils pkgs.systemd];
    text = ''
      if [ "$#" -gt 1 ]; then
        echo 'Usage: obsidian-sync-setup [remote-vault-name-or-id]' >&2
        exit 1
      fi
      umask 077
      vault=${lib.escapeShellArg (
        if cfg.remoteVault == null
        then ""
        else cfg.remoteVault
      )}
      vault="''${1:-$vault}"
      if [ -z "$vault" ]; then
        echo 'Pass the remote vault name or ID. List vaults with: ob login && ob sync-list-remote' >&2
        exit 1
      fi
      ob login
      mkdir -p -- ${lib.escapeShellArg cfg.vaultPath}
      ob sync-setup --vault "$vault" \
        --path ${lib.escapeShellArg cfg.vaultPath} \
        --device-name ${lib.escapeShellArg cfg.deviceName}
      ${configure}
      ob sync --path ${lib.escapeShellArg cfg.vaultPath}
      mkdir -p -- ${lib.escapeShellArg (builtins.dirOf readyFile)}
      touch -- ${lib.escapeShellArg readyFile}
      systemctl --user restart obsidian-sync.service
    '';
  };
in {
  options.my.home.services.obsidian-sync = {
    enable = lib.mkEnableOption "Obsidian Headless continuous vault sync";
    package = lib.mkPackageOption pkgs "obsidian-headless" {};
    vaultPath = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/vaults/notes";
      description = "Absolute path of the local vault.";
    };
    remoteVault = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Remote vault name or ID; if unset, pass it to obsidian-sync-setup.";
    };
    deviceName = lib.mkOption {
      type = lib.types.str;
      default = config.home.username;
      description = "Device name displayed in Obsidian Sync history.";
    };
    mode = lib.mkOption {
      type = lib.types.enum ["bidirectional" "pull-only" "mirror-remote"];
      default = "bidirectional";
      description = "Direction of vault synchronization.";
    };
    configs = lib.mkOption {
      type = lib.types.listOf (lib.types.enum [
        "app"
        "appearance"
        "appearance-data"
        "hotkey"
        "core-plugin"
        "core-plugin-data"
        "community-plugin"
        "community-plugin-data"
      ]);
      default = [];
      description = "Obsidian application configuration categories to sync.";
    };
    fileTypes = lib.mkOption {
      type = lib.types.listOf (lib.types.enum ["image" "audio" "video" "pdf" "unsupported"]);
      default = ["image" "audio" "video" "pdf" "unsupported"];
      description = "Attachment types to sync alongside notes.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = pkgs.stdenv.hostPlatform.isLinux;
        message = "obsidian-sync requires Linux systemd user services.";
      }
      {
        assertion = lib.hasPrefix "/" cfg.vaultPath;
        message = "obsidian-sync.vaultPath must be absolute.";
      }
    ];

    home.packages = [cfg.package setup];

    systemd.user.services.obsidian-sync = {
      Unit = {
        Description = "Obsidian Headless vault sync";
        StartLimitIntervalSec = 300;
        StartLimitBurst = 5;
      };
      Service = {
        # Setup creates this only after authentication and a successful sync.
        ExecCondition = "${pkgs.coreutils}/bin/test -f ${lib.escapeShellArg readyFile}";
        ExecStartPre = "${configure}";
        ExecStart = "${ob} sync --path ${lib.escapeShellArg cfg.vaultPath} --continuous";
        Restart = "on-failure";
        RestartSec = 10;
        UMask = "0077";
      };
      Install.WantedBy = ["default.target"];
    };
  };
}
