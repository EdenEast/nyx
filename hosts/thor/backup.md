# Obsidian backups

`backup.nix` configures Restic backups of `/home/eden/vaults/codex`, including
hidden files, attachments, and `.obsidian`. The repository is
`sftp://obsidian@vault:2222//mnt/Volume/Files/Backup/obsidian/codex`.

The hourly system timer runs without a login session, catches up after downtime,
and adds up to five minutes of jitter. Retention keeps 48 hourly, 30 daily,
12 weekly, and 12 monthly snapshots. A separate Sunday timer reads and verifies
all repository data. Jobs wait up to 30 minutes for a repository lock.
The backup reads the live vault; it is not an atomic filesystem snapshot.

Use URL syntax with a double slash before the absolute path when specifying
the SFTP port. A colon-style port in the repository address is interpreted as
part of a relative directory name, even if the SSH command uses port 2222.

## TrueNAS setup

1. Create a dedicated dataset or directory at
   `/mnt/Volume/Files/Backup/obsidian/codex`.
2. Create the `obsidian` user. Grant it traversal of the parent directories and
   read/write/delete access to the backup directory, without administrator or
   sudo privileges. Enable SSH access with a shell compatible with SFTP.
3. Add the three lines from [obsidian-authorized-keys.pub](./obsidian-authorized-keys.pub)
   to the user's SSH public key field. They authorize Thor's dedicated backup
   key and the existing `eden` client keys for Rize and Wrath. Preserve any
   existing authorized keys. Thor's backup key can also be read with:

   ```bash
   sudo cat /var/lib/obsidian-backup/id_ed25519.pub
   ```

4. Set the TrueNAS SSH service to port 2222 and start it at boot. SFTP uses that service;
   no Restic installation or SMTP server is required on TrueNAS.
5. Ensure `vault:2222` reaches the NAS filesystem. Tailscale SSH remains on
   port 22 for administration. Its app environment could not resolve the NAS
   `obsidian` user, so backups use TrueNAS OpenSSH on port 2222 instead.
6. Optionally configure periodic ZFS snapshots on the backup dataset, managed
   independently from Thor. These protect older repository states from deletion
   using Thor's backup credentials.

### Restic and restricted NFSv4 ACLs

Restic sets private permissions on the files it creates. A dataset with
`aclmode=restricted` rejects chmod on files that inherit nontrivial ACLs, even
when the backup account otherwise has full access. Use a dedicated dataset
with compatible permissions, or give this repository private, non-inheriting
ACLs. Do not change the ACL mode of the shared `Files` dataset for this backup.

The `codex` repository now has owner-only directory ACLs without inheritance.
New files receive private permissions that Restic can change. Normal backups,
locking, retention, a complete integrity check, and a verified restore passed.
The shared dataset's ACL mode and the parent directories were retained.

For a newly created repository with the same inheritance problem, scope the
directory ACL adjustment to that repository:

```bash
sudo find /mnt/Volume/Files/Backup/obsidian/codex -type d \
  -exec nfs4xdr_setfacl -s 'owner@:rwxpDdaARWcCos:-------:allow,group@:------a-R-c--s:-------:allow,everyone@:------a-R-c--s:-------:allow' {} \;
sudo nfs4xdr_getfacl /mnt/Volume/Files/Backup/obsidian/codex/locks
```

The repository must be owned by `obsidian`. Existing directories may still
report `trivial_acl: false`; the important change is that new files do not
inherit that ACL. Verify an ordinary Restic check and backup before relying on
the schedule. This adjustment has already been made for Thor's repository.

## Tailscale network setup

Use the TrueNAS SSH server over Tailscale, with authentication by the keys on the
`obsidian` account. Tailscale SSH intercepts tailnet port 22 and uses Tailscale
authentication instead of the NAS authorized keys.

1. Keep a working TrueNAS web UI or LAN SSH connection while changing the app.
2. In TrueNAS, edit the Tailscale app: disable Userspace networking and enable
   Host Network, as described in the
   [Tailscale TrueNAS guide](https://tailscale.com/docs/integrations/truenas).
3. Keep Tailscale SSH enabled on port 22 for administration. TrueNAS OpenSSH
   handles backup connections on port 2222 using the NAS account's public keys.
4. In the Tailscale admin console, identify the NAS device by its IP and make
   sure it is approved and online. Inspection found the direct NAS endpoint
   `vault` at `100.65.45.128`, while Hemera's SMB proxy was `vault-1` at
   `100.114.130.48`. Use the direct NAS endpoint for SSH.
5. In Access controls, ensure Thor, Rize, and Wrath can reach the NAS on TCP 2222.
   A network grant/ACL is required if the existing policy restricts this traffic.
   No Tailscale `ssh` rule is required for ordinary OpenSSH connections.
   Merge any needed network rule into the existing policy without replacing it.
6. Check device key expiry for the NAS and Thor. For unattended operation,
   disable expiry for those two trusted devices if appropriate for your tailnet.
7. Ensure MagicDNS resolves `vault` to the direct NAS endpoint. Test from Thor:

   ```bash
   tailscale ping vault
   ssh-keyscan -T 5 -p 2222 -t ed25519 vault
   ```

   The SSH host-key fingerprint should match TrueNAS's SSH key, verified
   through the NAS console. On Linux-based TrueNAS, an administrator can read
   the public host-key fingerprint with:

   ```bash
   sudo ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub
   ```

No exit node, subnet route, or internet port forwarding is needed for direct
tailnet access. Changing the TrueNAS app does not require changes to Hemera's
SMB proxy.

Test recovery access independently from Rize and Wrath using
`sftp -P 2222 obsidian@vault`; select the corresponding client identity if it is not
selected by default. Rize's configured client key is hardware-backed, so it
requires the matching token/agent to be available. SSH access alone cannot
decrypt a Restic backup: recovery hosts also need the repository password from
the password manager.

## Credentials and host verification

Runtime credentials are root-owned in `/var/lib/obsidian-backup` (mode 0700).
The repository password and dedicated unencrypted SSH private key were generated
there during setup. They are not in the Nix store or this repository. Existing
credentials must be retained when rebuilding; replacing the password will not
change an existing repository's encryption password.

Store the repository password in a password manager, along with the repository
address and a way to recover NAS access if Thor fails. Read the password privately
on Thor with `sudo cat /var/lib/obsidian-backup/password`.

Verify the NAS SSH host-key fingerprint through a trusted TrueNAS console or
administrator session. Then capture the selected endpoint's key into a temporary
file, compare its fingerprint, and install it only when it matches:

```bash
ssh-keyscan -p 2222 -t ed25519 vault > /tmp/obsidian-backup-known-hosts
ssh-keygen -lf /tmp/obsidian-backup-known-hosts
# After comparing with the trusted fingerprint:
sudo install -m 0600 /tmp/obsidian-backup-known-hosts /var/lib/obsidian-backup/known_hosts
```

Do not disable strict host checking. The services skip execution until the vault,
password, private key, and verified known-hosts file exist.

Test SFTP access as the same local user and with the same credentials as the
backup service:

```bash
sudo sftp -P 2222 -i /var/lib/obsidian-backup/id_ed25519 \
  -o IdentitiesOnly=yes -o BatchMode=yes -o StrictHostKeyChecking=yes \
  -o UserKnownHostsFile=/var/lib/obsidian-backup/known_hosts obsidian@vault
```

In the SFTP session, run `ls /mnt/Volume/Files/Backup/obsidian/codex`. The account must
also be able to create, rename, and delete files there. If chrooted, use the path
visible inside SFTP and update `backup.nix` accordingly.

## Activate and verify

From the Nyx checkout, after NAS setup and host verification:

```bash
sudo nixos-rebuild switch --flake 'path:.#thor'
sudo systemctl start restic-backups-obsidian.service
sudo restic-obsidian snapshots
sudo systemctl start restic-backups-obsidian-check.service
systemctl list-timers 'restic-backups-obsidian*'
journalctl -u restic-backups-obsidian -u restic-backups-obsidian-check
```

Perform a restore test into a fresh folder outside the synchronized vault:

```bash
sudo restic-obsidian restore latest:/home/eden/vaults/codex \
  --target /var/tmp/obsidian-restore-test --verify
```

Inspect recovered notes and attachments before considering setup complete.
Service failures appear in systemd/journald; email or push alerts are not
configured. Missing credential conditions skip jobs rather than marking them
failed, so check that a recent snapshot actually exists.

## Recovery

List backups with `sudo restic-obsidian snapshots`. Choose a snapshot from before
the unwanted change. For a single note:

```bash
sudo restic-obsidian restore SNAPSHOT_ID \
  --target /var/tmp/obsidian-note-recovery \
  --include '/home/eden/vaults/codex/Areas/Example.md' --verify
```

The recovered file is under
`/var/tmp/obsidian-note-recovery/home/eden/vaults/codex/Areas/Example.md`.
Inspect it, then copy it into the live vault as `eden` so Sync distributes the
recovered content.

For a complete rollback, stop `obsidian-sync` with
`systemctl --user stop obsidian-sync`, preserve the current vault, and restore a
chosen snapshot into a fresh directory using the full-vault restore command
above. Inspect it without connecting Sync. Reconcile the restored vault with
the remote vault and other devices before resuming synchronization.

If Thor is lost, install Restic on another machine with NAS access, supply the
repository address and saved password, and restore there. Thor's NixOS
installation is not required. Reauthorize a replacement SSH key on TrueNAS if
the original key is unavailable.

If the repository itself is damaged, preserve it and clone a suitable TrueNAS
snapshot to a separate dataset. Point Restic at that clone, run `restic check`,
then recover files from it. Avoid rolling back the live backup dataset while
backup jobs are running.
