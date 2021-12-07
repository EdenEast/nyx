{ pkgs ? import <nixpkgs> { } }:
let
  nixConf = import ./nix/conf.nix;
  options = [
    ''--option extra-trusted-substituters "${builtins.concatStringsSep " " nixConf.binaryCaches}"''
    ''--option extra-trusted-public-keys "${builtins.concatStringsSep " " nixConf.binaryCachePublicKeys}"''
    ''--option experimental-features "nix-command flakes"''
  ];
in
pkgs.mkShell {
  name = "nyx";
  nativeBuildInputs = with pkgs; [
    git
    git-crypt
    nixUnstable
  ];

  shellHook = ''
      PATH=${pkgs.writeShellScriptBin "nix" ''
      ${pkgs.nixFlakes}/bin/nix ${builtins.concatStringsSep " " options} "$@"
    ''}/bin:$PATH
  '';
}
