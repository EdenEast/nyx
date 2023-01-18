{ inputs, ... }:
_final: prev:

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
in
{
  neovim-unwrapped = inputs.neovim-flake.packages.${prev.system}.neovim.overrideAttrs (old: {
    patches = patchFilter old.patches ++ [ ./0001-Add-nix-short-rev-to-pre-release-version-info.patch ];
    NIX_SHORT_REV = inputs.neovim-flake.shortRev;
  });
  neovim-nightly = inputs.neovim-flake.packages.${prev.system}.neovim.overrideAttrs (old: {
    patches = patchFilter old.patches ++ [ ./0001-Add-nix-short-rev-to-pre-release-version-info.patch ];
    NIX_SHORT_REV = inputs.neovim-flake.shortRev;
  });
  neovim-debug = inputs.neovim-flake.packages.${prev.system}.neovim-debug.overrideAttrs (old: {
    patches = patchFilter old.patches ++ [ ./0001-Add-nix-short-rev-to-pre-release-version-info.patch ];
    NIX_SHORT_REV = inputs.neovim-flake.shortRev;
  });
  neovim-developer = inputs.neovim-flake.packages.${prev.system}.neovim-developer.overrideAttrs (old: {
    patches = patchFilter old.patches ++ [ ./0001-Add-nix-short-rev-to-pre-release-version-info.patch ];
    NIX_SHORT_REV = inputs.neovim-flake.shortRev;
  });
}
