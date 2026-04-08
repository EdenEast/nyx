_: {
  perSystem = {
    config,
    pkgs,
    inputs',
    ...
  }: {
    devShells.default = pkgs.mkShell {
      inputsFrom = [config.flake-root.devShell];
      name = "nyx";
      packages = with pkgs; [
        git-crypt
        nh
        watchexec
        inputs'.colmena.packages.colmena
        inputs'.ragenix.packages.default
      ];
    };
  };
}
