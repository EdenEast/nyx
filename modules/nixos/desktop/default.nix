{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = self.lib.importsAllNixFiles ./.;

  options.my.nixos.desktop = {
    enable = lib.mkEnableOption "minimal graphical desktop configuration";

    laptop = lib.mkOption {
      description = "Enable features for a laptop (trackpad, battery, etc...)";
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf config.my.nixos.desktop.enable {
    environment = {
      sessionVariables.NIXOS_OZONE_WL = "1";
      systemPackages = with pkgs; [
        wl-clipboard
        mpv
      ];
    };

    # home-manager.sharedModules = [
    #   {
    #     config.my.home.desktop.enable = true;
    #   }
    # ];

    fonts.packages = with pkgs.nerd-fonts; [
      # mono fonts
      jetbrains-mono
      hack
      ubuntu-mono

      # terminal pixel
      departure-mono
      envy-code-r
      terminess-ttf
    ];

    services = {
      gvfs.enable = true; # Mount, trash, etc.
      libinput = {
        enable = true;
        touchpad = lib.optionalAttrs config.my.nixos.desktop.laptop {
          tapping = true;
          naturalScrolling = true;
          disableWhileTyping = true; # if palm rejection is failing
        };
      };
    };

    my.nixos.services.yubikey.pinentry = lib.mkDefault pkgs.pinentry-qt;
  };
}
