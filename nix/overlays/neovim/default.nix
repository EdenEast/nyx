self: super:

let
  branch = "nightly";
  rev = "314b222c25f1f21713082d3cb17f5fa442a8b3ec";
  sha256 = "sha256-5Y7AYNyLTsmAXVo6dQlDAId2HWdQQRQlPPFUpKKK85Y=";
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

