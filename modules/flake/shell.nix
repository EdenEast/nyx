{self, ...}: {
  perSystem = {
    config,
    pkgs,
    inputs',
    ...
  }: let
    nixosHosts = builtins.attrNames self.nixosConfigurations;
    mkHostScript = host:
      pkgs.writeShellScriptBin host ''
        target="${host}"
        subcmd="''${1:build}"
        shift || true

        if [ "$(hostname)" = "$target" ]; then
          sudo nixos-rebuild --flake . "$subcmd" "$@"
        else
          case "$subcmd" in
            build)
              colmena build --on "$target" "$subcmd" "$@"
              ;;
            *)
              colmena apply --on "$target" "$subcmd" "$@"
              ;;
          esac
        fi
      '';
  in {
    devShells.default = pkgs.mkShell {
      inputsFrom = [config.flake-root.devShell];
      name = "nyx";
      packages =
        (with pkgs; [
          git-crypt
          nh
          watchexec
          inputs'.colmena.packages.colmena
          inputs'.ragenix.packages.default
        ])
        ++ map mkHostScript nixosHosts;
    };
  };
}
