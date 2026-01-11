{
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.xremap-flake.nixosModules.default
  ];

  options.my.nixos.profiles.keymap = {
    enable = lib.mkEnableOption "Remap keyboard";
  };

  config = lib.mkIf config.my.nixos.profiles.keymap.enable {
    services.xremap = {
      enable = true;
      config = {
        modmap = [
          {
            name = "CapsLock to RightCtrl/Esc";
            remap = {
              CapsLock = {
                held = "Ctrl_R";
                alone = "Esc";
                alone_timeout = 100;
              };
            };
          }
        ];

        keymap = [
          # {
          #   name = "RightCtrl+hjkl to Arrows";
          #   remap = {
          #     Ctrl_R-h = "Left";
          #     Ctrl_R-l = "Right";
          #     Ctrl_R-j = "Down";
          #     Ctrl_R-k = "Up";
          #   };
          # }
          {
            name = "RightCtrl + Esc to '~ and `'";
            remap = {
              Ctrl_R-Esc = "Grave";
              Ctrl_R-S-Esc = "S-Grave";
              Ctrl_R-Grave = "Grave";
              Ctrl_R-S-Grave = "S-Grave";
            };
          }
        ];
      };
    };
  };
}
# Current solution
#  - https://discourse.nixos.org/t/best-way-to-remap-caps-lock-to-esc-with-wayland/39707/2
#
# Previous solution
# - https://discourse.nixos.org/t/best-way-to-remap-caps-lock-to-esc-with-wayland/39707/6

