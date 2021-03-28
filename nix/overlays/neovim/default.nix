self: super:

let
  branch = "nightly";
  rev = "8665a96b92553b26c8c9c215900964b8a898595f";
  sha256 = "sha256-dYUShXDLs/WJ0a/S1UBqTcNqzKDXIg7osRe3HmuR2n8=";
in {
  neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (old: rec {
    version = "0.5.0-${branch}";
    src = super.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = rev;
      sha256 = sha256;
    };

    buildInputs = old.buildInputs ++ [ super.pkgs.tree-sitter ];
  });
}

