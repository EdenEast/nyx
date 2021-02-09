self: super:

let
  branch = "nightly";
  rev = "02a3c417945e7b7fc781906a78acbf88bd44c971";
  sha256 = "3sSRuFF5Vy131D7WjuzzIAxG5JHb1tBzsCXfsJ9L5po=";
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

