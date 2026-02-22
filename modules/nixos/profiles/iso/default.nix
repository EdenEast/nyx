{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  options.my.nixos.profiles.iso.enable = lib.mkEnableOption "based system configuration for ISO images";

  config = lib.mkIf config.my.nixos.profiles.iso.enable {
    boot = {
      kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

      supportedFilesystems = lib.mkForce [
        "btrfs"
        "vfat"
        "f2fs"
        "xfs"
        "ntfs"
        "cifs"
      ];
    };

    documentation.nixos.enable = false;
    environment = {
      etc."nixos".source = self;

      systemPackages = with pkgs; [
        neovim
        htop
        lm_sensors
        wget
      ];
    };

    nix.distributedBuilds = lib.mkForce false;

    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
        silent = true;
      };

      git = {
        enable = true;
        package = pkgs.gitMinimal;
      };
    };

    system = {
      configurationRevision = self.rev or self.dirtyRev or null;
      switch.enable = false;
    };

    users.defaultUserShell = lib.mkForce pkgs.bash;
  };
}
