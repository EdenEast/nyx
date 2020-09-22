{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    gnumake
    nixFlakes
    nixfmt

    # keep this line if you use bash
    pkgs.bashInteractive
  ];
}
