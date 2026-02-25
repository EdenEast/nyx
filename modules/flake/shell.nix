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
        inputs'.ragenix.packages.default
      ];
    };
  };
}
