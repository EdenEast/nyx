_: {
  perSystem = {pkgs, ...}: {
    packages = {
      fwhich = pkgs.writeShellApplication {
        name = "fwhich";
        text = builtins.readFile ./fwhich;
      };
    };
  };
}
