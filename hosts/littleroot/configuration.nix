{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
  ];

  image.baseName = lib.mkForce "littleroot";
  networking.hostName = "littleroot";
  nixpkgs.hostPlatform = "x86_64-linux";

  my = {
    nixos = {
      desktop.gnome.enable = true;
      profiles.iso.enable = true;
      programs.nix.enable = true;
    };

    users.root.enable = true;
  };
}
