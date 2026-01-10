_: {
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      inputsFrom = [config.flake-root.devShell];
      name = "nyx";
      packages = with pkgs; [
        git-crypt
        nh
        watchexec
      ];
    };
  };
}
