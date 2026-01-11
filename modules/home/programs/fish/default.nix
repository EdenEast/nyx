{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.home.programs.fish = {
    # FIXME: This option should not be necessary and should be able to use `config.programs.fish.enable` instead however
    # this currently does not work as fish is set as the user's default shell and enabled in the nixos module and the
    # value is not passed or reconized by the home-manager module. Meaning that if it is set in the nixos module it
    # would not be enabled in the home-manager module
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable fish shell and related configuration.";
    };
  };

  config = lib.mkIf config.my.home.programs.fish.enable (lib.mkMerge [
    {
      programs.fish = {
        enable = true;

        shellAliases = import ../../base/shells/aliases.nix;
        functions = import ./functions.nix {inherit pkgs lib;};

        interactiveShellInit = let
          localDataPath = "${config.xdg.dataHome}/fish/config.fish";
        in
          # fish
          ''
            set -g fish_greeting

            # escape hatch from nix for experimentations
            if test -f ${localDataPath}
              source ${localDataPath}
            end
          '';
      };

      # Required to be defined to be callable but disabling so file does not get generated
      xdg.dataFile."fish/config.fish".enable = false;

      home.packages = with pkgs; [
        fishPlugins.fzf-fish
        fishPlugins.colored-man-pages
      ];
    }

    (lib.mkIf config.my.home.base.shells.wsl {
      home.packages = with pkgs; [
        iproute2
        socat
      ];

      programs.fish.shellInitLast =
        # fish
        ''
          set windows_destination /mnt/c/Users/Public/Downloads/wsl2-ssh-pageant.exe
          set linux_destination $HOME/.ssh/wsl2-ssh-pageant.exe

          if not test -x $linux_destination
              curl -O $windows_destination https://github.com/BlackReloaded/wsl2-ssh-pageant/releases/latest/download/wsl2-ssh-pageant.exe
              chmod +x $windows_destination
              ln -s $windows_destination $linux_destination
          end

          # Handle ssh socket
          set -x SSH_AUTH_SOCK "$HOME/.ssh/agent.sock"
          if not ss -a | grep -q "$SSH_AUTH_SOCK";
            rm -f "$SSH_AUTH_SOCK"
            set wsl2_ssh_pageant_bin "$HOME/.ssh/wsl2-ssh-pageant.exe"
            if test -x "$wsl2_ssh_pageant_bin";
              setsid nohup socat UNIX-LISTEN:"$SSH_AUTH_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin" >/dev/null 2>&1 &
            else
              echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
            end
            set --erase wsl2_ssh_pageant_bin
          end

          # Handle gpg socket
          set -x GPG_AGENT_SOCK "$HOME/.gnupg/S.gpg-agent"
          if not ss -a | grep -q "$GPG_AGENT_SOCK";
            rm -rf "$GPG_AGENT_SOCK"
            set wsl2_ssh_pageant_bin "$HOME/.ssh/wsl2-ssh-pageant.exe"
            if test -x "$wsl2_ssh_pageant_bin";
              setsid nohup socat UNIX-LISTEN:"$GPG_AGENT_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin --gpg S.gpg-agent" >/dev/null 2>&1 &
            else
              echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
            end
            set --erase wsl2_ssh_pageant_bin
          end

          set --erase windows_destination
          set --erase linux_destination
        '';
    })
  ]);
}
