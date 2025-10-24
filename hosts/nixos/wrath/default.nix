{inputs, ...}: {
  imports = [
    ./hardware.nix
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  hardware.keyboard.qmk.enable = true;
}
