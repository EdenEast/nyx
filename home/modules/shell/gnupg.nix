{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.modules.shell.gnupg;
  mkEnableTrueOption = name: mkEnableOption name // { default = true; };

  homeDirectory = config.home.homeDirectory;

  wsl2-ssh-pageant = pkgs.fetchurl {
    url = "https://github.com/BlackReloaded/wsl2-ssh-pageant/releases/download/v1.2.0/wsl2-ssh-pageant.exe";
    hash = "sha256-/iKUsFC3BFS7A47HuUqDV8RfjT1MUFpPN05KSVv8ryc=";
  };
in
{
  options.nyx.modules.shell.gnupg = {
    enable = mkEnableOption "gnupg configuration";

    wslCompatibility = mkOption {
      type = types.bool;
      default = false;
      description = "Use npiperelay and wsl-pageant on WSL.";
    };

    publicKey = mkOption {
      type = with types; nullOr path;
      default = null;
      description = "Gpg public key";
    };
  };

  config = mkIf cfg.enable (
    mkMerge [
      (
        mkIf (cfg.publicKey != null) {
          home.file.".gnupg/public.key".source = cfg.publicKey;
          home.activation.gpgtrust = hm.dag.entryAfter [ "linkGeneration" ] (
            ''
              gpg --import ~/.gnupg/public.key
            ''
          );
        }
      )

      {
        programs.gpg = {
          enable = true;
          settings = {
            personal-cipher-preferences = "AES256 AES192 AES";
            personal-digest-preferences = "SHA512 SHA384 SHA256";
            personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
            default-preference-list =
              "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
            cert-digest-algo = "SHA512";
            s2k-digest-algo = "SHA512";
            s2k-cipher-algo = "AES256";
            charset = "utf-8";
            fixed-list-mode = true;
            no-comments = true;
            no-emit-version = true;
            no-greeting = true;
            keyid-format = "0xlong";
            list-options = "show-uid-validity";
            verify-options = "show-uid-validity";
            with-fingerprint = true;
            require-cross-certification = true;
            no-symkey-cache = true;
            use-agent = true;
            throw-keyids = true;
          };
        };

        services.gpg-agent = {
          enable = !cfg.wslCompatibility;
          enableExtraSocket = true;
          enableScDaemon = true;
          enableSshSupport = true;
          verbose = true;
        };
      }
      {
        # To be able to access the GPG and SSH of the Yubikey from within WSL 2, there is some setup
        # required. First, install gpg4win. Next, run the following commands:
        #
        # ```powershell
        # mkdir $env:APPDATA\gnupg
        # Add-Content -Path $env:APPDATA\gnupg\gpg-agent.conf -Encoding utf8 -Value "enable-putty-support`r`nenable-ssh-support"
        # Register-ScheduledJob -Name GpgAgent -Trigger (New-JobTrigger -AtLogOn) -Credential (Get-Credential) -RunNow -ScriptBlock {
        #   & "${env:ProgramFiles(x86)}/GnuPG/bin/gpg-connect-agent.exe" --options $env:APPDATA\gnupg\gpg-agent.conf /bye
        # }
        # ```
        #
        # On Linux, gpg-agent sockets are placed in `/run`, which is symlinked to
        # `$HOME/.gnupg/socketdir`. On Windows, sockets are forwarded using wsl2-ssh-pageant directly
        # to `$HOME/.gnupg/socketdir`. In either case, this provides a predictable path that can be
        # used by SSH configuration.
        #
        # NOTE: Unless socat was executed before `exec`ing into fish, it wouldn't launch the
        # `wsl2-ssh-pageant.exe` process.
        nyx.modules.shell.bash.profileExtra = mkIf cfg.wslCompatibility ''
          mkdir -p ${homeDirectory}/.gnupg/socketdir
          if test ! -f "${homeDirectory}/.gnupg/wsl2-ssh-pageant.exe"; then
            cp ${wsl2-ssh-pageant} ${homeDirectory}/.gnupg/wsl2-ssh-pageant.exe
            chmod +x ${homeDirectory}/.gnupg/wsl2-ssh-pageant.exe
          fi
          export GPG_AGENT_SOCK=${homeDirectory}/.gnupg/S.gpg-agent
          ss -a | grep -q $GPG_AGENT_SOCK
          if [ $? -ne 0 ]; then
            rm -rf $GPG_AGENT_SOCK
            (setsid nohup socat UNIX-LISTEN:$GPG_AGENT_SOCK,fork EXEC:"$HOME/.gnupg/wsl2-ssh-pageant.exe --gpg S.gpg-agent",nofork >/dev/null 2>&1 &)
          fi
          export GPG_AGENT_EXTRA_SOCK=${homeDirectory}/.gnupg/socketdir/S.gpg-agent.extra
          ss -a | grep -q $GPG_AGENT_EXTRA_SOCK
          if [ $? -ne 0 ]; then
            rm -rf $GPG_AGENT_EXTRA_SOCK
            (setsid nohup socat UNIX-LISTEN:$GPG_AGENT_EXTRA_SOCK,fork EXEC:"$HOME/.gnupg/wsl2-ssh-pageant.exe --gpg S.gpg-agent.extra",nofork >/dev/null 2>&1 &)
          fi
          export SSH_AUTH_SOCK=${homeDirectory}/.gnupg/socketdir/S.gpg-agent.ssh
          ss -a | grep -q $SSH_AUTH_SOCK
          if [ $? -ne 0 ]; then
            rm -f $SSH_AUTH_SOCK
            (setsid nohup socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"$HOME/.gnupg/wsl2-ssh-pageant.exe",nofork >/dev/null 2>&1 &)
          fi
        '';
      }
    ]
  );
}
