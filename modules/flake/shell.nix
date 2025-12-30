_: {
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShell {
      name = "nyx";
      packages = with pkgs; [
        git
        git-crypt
        nh
        watchexec
      ];
    };
  };
}
