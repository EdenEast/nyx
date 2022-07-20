{ inputs, ... }:
_final: prev:

{
  neovim-unwrapped = inputs.neovim-flake.packages.${prev.system}.neovim.overrideAttrs (old: {
    patches = old.patches ++ [ ./0001-Add-nix-short-rev-to-pre-release-version-info.patch ];
    NIX_SHORT_REV = inputs.neovim-flake.shortRev;
  });
  neovim-nightly = inputs.neovim-flake.packages.${prev.system}.neovim.overrideAttrs (old: {
    patches = old.patches ++ [ ./0001-Add-nix-short-rev-to-pre-release-version-info.patch ];
    NIX_SHORT_REV = inputs.neovim-flake.shortRev;
  });
  neovim-debug = inputs.neovim-flake.packages.${prev.system}.neovim-debug.overrideAttrs (old: {
    patches = old.patches ++ [ ./0001-Add-nix-short-rev-to-pre-release-version-info.patch ];
    NIX_SHORT_REV = inputs.neovim-flake.shortRev;
  });
  neovim-developer = inputs.neovim-flake.packages.${prev.system}.neovim-developer.overrideAttrs (old: {
    patches = old.patches ++ [ ./0001-Add-nix-short-rev-to-pre-release-version-info.patch ];
    NIX_SHORT_REV = inputs.neovim-flake.shortRev;
  });
}
