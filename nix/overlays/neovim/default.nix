{ inputs, ... }:
final: prev:

# NixOS/nixpkgs#208103 introduced a patch that makes builds reproduceable.
# This patch applies to the current 0.8.2 but does not apply to nightly.
# Filtering out this patch.
let
  patchFilter = v: builtins.filter
    (p:
      let patch = if builtins.typeOf p == "set" then baseNameOf p.name else baseNameOf p;
      in patch != "neovim-build-make-generated-source-files-reproducible.patch"
    )
    v;

  # This is only required as lpeg was added as a library dependency in pr: https://github.com/neovim/neovim/pull/23216
  # This can be removed when 0.10 is released and nixpkgs is updated.
  liblpeg = final.stdenv.mkDerivation {
    pname = "liblpeg";
    inherit (final.luajitPackages.lpeg) version meta src;

    buildInputs = [ final.luajit ];

    buildPhase = ''
      sed -i makefile -e "s/CC = gcc/CC = clang/"
      sed -i makefile -e "s/-bundle/-dynamiclib/"
      make macosx
    '';

    installPhase = ''
      mkdir -p $out/lib
      mv lpeg.so $out/lib/lpeg.dylib
    '';

    nativeBuildInputs = [ final.fixDarwinDylibNames ];
  };
in
{
  # neovim-unwrapped = inputs.neovim-flake.packages.${prev.system}.neovim.overrideAttrs (old: {
  #   patches = patchFilter old.patches ++ [ ./0001-Add-nix-short-rev-to-pre-release-version-info.patch ];
  #   NIX_SHORT_REV = inputs.neovim-flake.shortRev;
  # });
  neovim-nightly = inputs.neovim-flake.packages.${prev.system}.neovim.overrideAttrs (old: {
    # patches = patchFilter old.patches ++ [ ./0001-Add-nix-short-rev-to-pre-release-version-info.patch ];
    patches = old.patches ++ [ ./0001-Add-nix-short-rev-to-pre-release-version-info.patch ];
    NIX_SHORT_REV = inputs.neovim-flake.shortRev;
    nativeBuildInputs = old.nativeBuildInputs ++ (prev.lib.optionals prev.stdenv.isDarwin [ liblpeg ]);
  });
  neovim-debug = inputs.neovim-flake.packages.${prev.system}.neovim-debug.overrideAttrs (old: {
    patches = patchFilter old.patches ++ [ ./0001-Add-nix-short-rev-to-pre-release-version-info.patch ];
    NIX_SHORT_REV = inputs.neovim-flake.shortRev;
    nativeBuildInputs = old.nativeBuildInputs ++ (prev.lib.optionals prev.stdenv.isDarwin [ liblpeg ]);
  });
  neovim-developer = inputs.neovim-flake.packages.${prev.system}.neovim-developer.overrideAttrs (old: {
    patches = patchFilter old.patches ++ [ ./0001-Add-nix-short-rev-to-pre-release-version-info.patch ];
    NIX_SHORT_REV = inputs.neovim-flake.shortRev;
    nativeBuildInputs = old.nativeBuildInputs ++ (prev.lib.optionals prev.stdenv.isDarwin [ liblpeg ]);
  });
}
