{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  name = "nyx";
  nativeBuildInputs = with pkgs; [
    nix
    git
    git-crypt
  ];
}
