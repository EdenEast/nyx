{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = self.lib.importsAllNixFiles ./.;

  options.myNixOS.desktop = {
    enable = lib.mkEnableOption "minimal graphical desktop configuration";

    laptop = lib.mkOption {
      description = "Enable features for a laptop (trackpad, battery, etc...)";
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf config.myNixOS.desktop.enable {
    environment = {
      sessionVariables.NIXOS_OZONE_WL = "1";
      systemPackages = [
        pkgs.wl-clipboard
      ];
    };

    # home-manager.sharedModules = [
    #   {
    #     config.myHome.desktop.enable = true;
    #   }
    # ];

    fonts.packages = with pkgs.nerd-fonts; [
      jetbrains-mono
      hack
      gohufont
      meslo-lg
      ubuntu-mono
    ];

    services = {
      gvfs.enable = true; # Mount, trash, etc.
      libinput = {
        enable = true;
        touchpad = lib.optionalAttrs config.myNixOS.desktop.laptop {
          tapping = true;
          naturalScrolling = true;
          # disableWhileTyping = true; # if palm rejection is failing
        };
      };
    };

    myNixOS.services.yubikey.pinentry = lib.mkDefault pkgs.pinentry-qt;
  };
}
