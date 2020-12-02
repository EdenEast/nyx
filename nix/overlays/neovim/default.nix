self: super:

let metadata = import ./metadata.nix;
in {
  neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (old: rec {
    version = "0.5.0-${metadata.branch}";
    src = super.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = metadata.rev;
      sha256 = metadata.sha256;
    };

    buildInputs = old.buildInputs ++ [ super.pkgs.tree-sitter ];
  });
}

