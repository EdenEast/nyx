{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myNixOS.profiles.wsl;
in {
  options.myNixOS.profiles.wsl = {
    enable = lib.mkEnableOption "printing support";

    defaultUser = lib.mkOption {
      type = lib.types.str;
      default = "nixos";
      description = "Set defualt user of wsl";
    };

    ssh-agent = lib.mkOption {
      default = {};
      type = lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "ssh-agent passthrough to Windows";

          package = lib.mkPackageOption pkgs "wsl2-ssh-agent" {};

          users = lib.mkOption {
            type = let
              inherit (lib.types) either enum listOf;
              userNames = lib.attrNames config.users.users;
            in
              either
              (enum [
                "!@system"
                "@system"
              ])
              (listOf (enum userNames));
            default = "!@system";
            description = ''
              Users to activate the service for. Defaults to all non-system users.
            '';
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    wsl = {
      inherit (cfg) defaultUser;
      enable = true;
      wslConf = {
        automount.root = "/mnt";
        interop.appendWindowsPath = true;
      };
    };

    # Ensure that we dont enable network manager because we are on wsl
    networking.networkmanager.enable = lib.mkForce false;

    # Handle ssh-agent passthrough to windows
    systemd.user.services.wsl2-ssh-agent = lib.mkIf (cfg.ssh-agent.enable) {
      description = "WSL2 SSH Agent Bridge";
      after = ["network.target"];
      wantedBy = ["default.target"];
      unitConfig = {
        ConditionUser = lib.join "|" (lib.toList cfg.ssh-agent.users);
      };
      serviceConfig = {
        ExecStart = "${cfg.ssh-agent.package}/bin/wsl2-ssh-agent --verbose --foreground --socket=%t/wsl2-ssh-agent.sock";
        Restart = "on-failure";
      };
    };

    environment.variables.SSH_AUTH_SOCK = lib.mkIf (cfg.ssh-agent.enable) "$XDG_RUNTIME_DIR/wsl2-ssh-agent.sock";

    myNixOS.programs.nix.enable = true;
  };
}
