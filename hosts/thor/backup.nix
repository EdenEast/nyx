{pkgs, ...}: let
  # Runtime secrets stay outside the repository and the Nix store.
  credentials = "/var/lib/obsidian-backup";
  vaultPath = "/home/eden/vaults/codex";
  repository = "sftp://obsidian@vault:2222//mnt/Volume/Files/Backup/obsidian/codex";
  passwordFile = "${credentials}/password";
  sshCommand = builtins.concatStringsSep " " [
    "${pkgs.openssh}/bin/ssh"
    "-p 2222"
    "-i ${credentials}/id_ed25519"
    "-o IdentitiesOnly=yes"
    "-o BatchMode=yes"
    "-o StrictHostKeyChecking=yes"
    "-o UserKnownHostsFile=${credentials}/known_hosts"
    "-o ConnectTimeout=30"
    "-o ServerAliveInterval=15"
    "-o ServerAliveCountMax=3"
    "obsidian@vault -s sftp"
  ];
  common = {
    inherit repository passwordFile;
    extraOptions = ["sftp.command='${sshCommand}'"];
  };
  conditions = [
    vaultPath
    passwordFile
    "${credentials}/id_ed25519"
    "${credentials}/known_hosts"
  ];
in {
  systemd.tmpfiles.rules = ["d ${credentials} 0700 root root -"];

  services.restic.backups = {
    obsidian =
      common
      // {
        paths = [vaultPath];
        initialize = true;
        extraBackupArgs = ["--host thor" "--tag obsidian" "--retry-lock 30m"];
        timerConfig = {
          OnCalendar = "hourly";
          Persistent = true;
          RandomizedDelaySec = "5m";
        };
        pruneOpts = [
          "--retry-lock 30m"
          "--host thor"
          "--tag obsidian"
          "--keep-hourly 48"
          "--keep-daily 30"
          "--keep-weekly 12"
          "--keep-monthly 12"
        ];
      };

    # Read all stored data weekly, rather than just checking metadata.
    obsidian-check =
      common
      // {
        paths = [];
        runCheck = true;
        checkOpts = ["--read-data" "--retry-lock 30m"];
        createWrapper = false;
        timerConfig = {
          OnCalendar = "Sun *-*-* 03:30:00";
          Persistent = true;
          RandomizedDelaySec = "15m";
        };
      };
  };

  systemd.services = {
    restic-backups-obsidian = {
      unitConfig.ConditionPathExists = conditions;
      serviceConfig.UMask = "0077";
    };
    restic-backups-obsidian-check = {
      unitConfig.ConditionPathExists = conditions;
      serviceConfig.UMask = "0077";
    };
  };
}
