{ inputs, ... }:
_final: prev:

{
  neovim-unwrapped = inputs.neovim-flake.packages.${prev.system}.neovim;
  neovim-nightly = inputs.neovim-flake.packages.${prev.system}.neovim;
  neovim-debug = inputs.neovim-flake.packages.${prev.system}.neovim-debug;
  neovim-developer = inputs.neovim-flake.packages.${prev.system}.neovim-developer;
}
