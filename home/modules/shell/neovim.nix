{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.modules.shell.neovim;
in
{
  options.nyx.modules.shell.neovim = {
    enable = mkEnableOption "neovim configuration";

    useNightly = mkOption {
      description = "Use the nightly neovoim instead of latest stable";
      type = with types; bool;
      default = false;
    };

    extraPkgs = mkOption {
      description = "List of extra packages required for neovim config";
      type = with types; listOf package;
      default = with pkgs; [
        # sqlite
        nodejs # required for things like markdown-preview and asciidoc-preview
      ];
    };

    # Rust is handled by the dev/rust.nix file as there is more to setup for that env
    lspServers = mkOption {
      description = "List of language server packages";
      type = with types; listOf package;
      default = with pkgs; [
        marksman
        nodePackages.bash-language-server
        nodePackages.pyright
        nodePackages.typescript-language-server
        nodePackages.vim-language-server
        nodePackages.write-good
        rnix-lsp
      ] ++ optionals pkgs.stdenv.isLinux [
        omnisharp-roslyn
        lua-language-server
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
        proselint
        nodePackages.eslint_d
        nodePackages.yaml-language-server
      ];
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile."nvim".source = ../../../config/.config/nvim;
    home.packages = with pkgs;
      let
        package = if cfg.useNightly then neovim-nightly else neovim;
      in
      [ package xclip ] ++ cfg.lspServers ++ cfg.debugAdaptors ++ cfg.formatters ++ cfg.extraPkgs;

    nyx.modules.shell.vale.enable = true;

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
      # parsers = listToAttrs (map
      #   (p: {
      #     name = "nvim/parser/${parseName p}.so";
      #     value = { source = "${p}/parser"; };
      #   })
      #   grammars);
      parsers = { };
    in
    parsers // {
      "nvim/lib/libsqlite3.so".source = "${pkgs.sqlite.out}/lib/libsqlite3.so";
    };
  };
}
