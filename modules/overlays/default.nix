{
  self,
  inputs,
  ...
}: let
  inherit (self.lib) forAllNixFiles specialArgsFor;
in {
  flake.overlays.default = _final: prev:
    with inputs; let
      inherit (prev.stdenv) system;
      nixpkgs-stable =
        if prev.stdenv.isDarwin
        then nixpkgs-stable-darwin
        else nixos-stable;
    in
      {
        master = nixpkgs-master.legacyPackages.${system};
        stable = nixpkgs-stable.legacyPackages.${system};
      }
      // forAllNixFiles ./. (_name: fn: import fn specialArgsFor.common);

  # perSystem = {system, ...}: {
  #   _module.args.pkgs = import inputs.nixpkgs {
  #     inherit system;
  #     overlays = [
  #       self.overlays.default
  #     ];
  #   };
  # };
}
