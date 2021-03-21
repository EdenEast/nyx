self: super:

let
  branch = "nightly";
  rev = "070e084a64dd08ff28c826843f0d61ca51837841";
  sha256 = "sha256-rWLubr/XtEWSWUZbcg5lxp3DGjWwc67DwSi0lOeHV+Y=";
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

