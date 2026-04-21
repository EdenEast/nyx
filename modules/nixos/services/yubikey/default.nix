{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.programs.gnupg) package;
  cfg = config.my.nixos.services.yubikey;

  findUsbipd = ''
    usbipd="$(which usbipd.exe)"
  '';

  toggleScript = pkgs.writeShellScriptBin "toggle-yubikey" ''
    set -euo pipefail

    ${findUsbipd}
    if [[ -z "$usbipd" ]]; then
      echo "error: usbipd.exe not found. Install usbipd-win on Windows." >&2
      exit 1
    fi

    line=$("$usbipd" list 2>/dev/null | grep -i "1050:") || true
    if [[ -z "$line" ]]; then
      echo "YubiKey not found. Is it plugged in?" >&2
      exit 1
    fi

    busid=$(echo "$line" | awk '{print $1}')

    if echo "$line" | grep -qi "Attached"; then
      echo "Detaching YubiKey (bus $busid) from WSL..."
      "$usbipd" detach --busid "$busid"
      echo "Done. YubiKey returned to Windows."
    else
      if echo "$line" | grep -qi "Not shared"; then
        echo "Binding YubiKey (may require Windows admin elevation)..."
        "$usbipd" bind --busid "$busid"
      fi
      echo "Attaching YubiKey (bus $busid) to WSL..."
      "$usbipd" attach --wsl --busid "$busid"
      echo "Done. YubiKey available in WSL."
    fi
  '';

  detachScript = pkgs.writeShellScript "yubikey-wsl-detach" ''
    ${findUsbipd}
    [[ -z "$usbipd" ]] && exit 0

    line=$("$usbipd" list 2>/dev/null | grep -i "1050:") || true
    [[ -z "$line" ]] && exit 0
    echo "$line" | grep -qi "Attached" || exit 0

    busid=$(echo "$line" | awk '{print $1}')
    "$usbipd" detach --busid "$busid" || true
  '';
in {
  options.my.nixos.services.yubikey = {
    enable = lib.mkEnableOption "Yubikey support for gpg and ssh-agent";
    pinentry = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = pkgs.pinentry-tty;
    };
    wsl.enable = lib.mkEnableOption "WSL2 usbipd toggle and auto-detach on shutdown";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
        pinentryPackage = cfg.pinentry;
      };

      environment = {
        shellInit = ''
          export GPG_TTY="$(tty)"
          gpg-connect-agent /bye
          export SSH_AUTH_SOCK=$(${package}/bin/gpgconf --list-dirs agent-ssh-socket) # marker
        '';
        variables = {
          SSH_AUTH_SOCK = "$(${package}/bin/gpgconf --list-dirs agent-ssh-socket)";
        };
      };

      services = {
        pcscd.enable = true;

        udev.packages = with pkgs; [
          libu2f-host
          yubikey-personalization
        ];
      };
    })

    (lib.mkIf (cfg.enable && cfg.wsl.enable) {
      environment.systemPackages = [toggleScript];

      services = {
        # nixos-wsl disables udev, but we need it for YubiKey USB device permissions
        udev.enable = lib.mkForce true;

        # pcscd runs as the 'pcscd' system user; give it rw access to Yubico USB
        # devices via plugdev so libusb can open the CCID interface.
        udev.extraRules = ''
          SUBSYSTEM=="usb", ATTRS{idVendor}=="1050", GROUP="plugdev", MODE="0660"
        '';
      };

      users.users.pcscd.extraGroups = ["plugdev"];

      systemd.services.yubikey-wsl-detach = {
        description = "Detach YubiKey from WSL on shutdown";
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${pkgs.coreutils}/bin/true";
          ExecStop = detachScript;
          # Include common Windows paths so usbipd.exe is reachable at shutdown
          Environment = "PATH=/run/wrappers/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/bin:/bin:/mnt/c/Windows/System32:/mnt/c/Windows:/mnt/c/Program Files/usbipd-win";
        };
      };
    })
  ];
}
