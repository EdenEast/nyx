{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.modules.shell.neovim;
in
{
  options.nyx.modules.shell.neovim = {
    enable = mkEnableOption "neovim configuration";

    extraPkgs = mkOption {
      description = "List of extra packages required for neovim config";
      type = with types; listOf package;
      default = with pkgs; [
        # sqlite
      ];
    };

    # Rust is handled by the dev/rust.nix file as there is more to setup for that env
    lspServers = mkOption {
      description = "List of language server packages";
      type = with types; listOf package;
      default = with pkgs; [
        # cmake-language-server
        # elmPackages.elm-language-server
        efm-lsp
        nodePackages.bash-language-server
        nodePackages.pyright
        nodePackages.typescript-language-server
        nodePackages.vim-language-server
        rnix-lsp
      ] ++ optionals pkgs.stdenv.isLinux [
        omnisharp-roslyn
        sumneko-lua-language-server
      ];
    };

    debugAdaptors = mkOption {
      description = "List of debug adaptor packages";
      type = with types; listOf package;
      default = with pkgs; [
      ] ++ optionals pkgs.stdenv.isLinux [
        lldb
      ];
    };

    formatters = mkOption {
      description = "List of formatters and linters";
      type = with types; listOf package;
      default = with pkgs; [
        stylua
        shfmt
        nixpkgs-fmt
        prettierd
        nodePackages.eslint_d
      ];
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile."nvim".source = ../../../config/.config/nvim;
    home.packages = with pkgs; [
      neovim-nightly
    ] ++ cfg.lspServers ++ cfg.debugAdaptors ++ cfg.formatters ++ cfg.extraPkgs;

    # Add Treesitter parsers
    xdg.dataFile = with pkgs.tree-sitter-grammars; let
      grammars = with pkgs.tree-sitter-grammars; [
        tree-sitter-bash
        tree-sitter-c
        tree-sitter-c-sharp
        tree-sitter-comment
        tree-sitter-cpp
        tree-sitter-css
        tree-sitter-go
        tree-sitter-javascript
        tree-sitter-json
        tree-sitter-lua
        tree-sitter-make
        # Currently this does not point to the correct markdown parser
        # Correct one is: https://github.com/MDeiml/tree-sitter-markdown
        # tree-sitter-markdown
        tree-sitter-nix
        tree-sitter-regex
        tree-sitter-rust
        tree-sitter-toml
        tree-sitter-tsx
        tree-sitter-typescript
        tree-sitter-vim
        tree-sitter-yaml
      ];
      parseName = x: removeSuffix "-grammar" (removePrefix "tree-sitter-" (getName x));
      parsers = listToAttrs (map
        (p: {
          name = "nvim/parser/${parseName p}.so";
          value = { source = "${p}/parser"; };
        })
        grammars);
    in
    parsers // {
      "nvim/lib/libsqlite3.so".source = "${pkgs.sqlite.out}/lib/libsqlite3.so";
    };
  };
}
