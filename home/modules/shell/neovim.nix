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
    # home.packages = with pkgs; [ neovim-nightly ];
    xdg.configFile."nvim".source = ../../../config/.config/nvim;
    home.packages = with pkgs; [
      neovim-unwrapped
    ] ++ cfg.lspServers ++ cfg.debugAdaptors ++ cfg.formatters ++ cfg.extraPkgs;

    # Add Treesitter parsers
    home.file = {
      "${config.xdg.dataHome}/nvim/lib/libsqlite3.so".source = "${pkgs.sqlite.out}/lib/libsqlite3.so";
      "${config.xdg.dataHome}/nvim/parser/bash.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-bash}/parser";
      "${config.xdg.dataHome}/nvim/parser/c.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-c}/parser";
      "${config.xdg.dataHome}/nvim/parser/cpp.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-cpp}/parser";
      "${config.xdg.dataHome}/nvim/parser/css.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-css}/parser";
      "${config.xdg.dataHome}/nvim/parser/fennel.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-fennel}/parser";
      "${config.xdg.dataHome}/nvim/parser/go.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-go}/parser";
      "${config.xdg.dataHome}/nvim/parser/haskell.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-haskell}/parser";
      "${config.xdg.dataHome}/nvim/parser/html.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-html}/parser";
      "${config.xdg.dataHome}/nvim/parser/javascript.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-javascript}/parser";
      "${config.xdg.dataHome}/nvim/parser/json.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-json}/parser";
      "${config.xdg.dataHome}/nvim/parser/lua.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-lua}/parser";
      "${config.xdg.dataHome}/nvim/parser/markdown.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-markdown}/parser";
      "${config.xdg.dataHome}/nvim/parser/nix.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-nix}/parser";
      "${config.xdg.dataHome}/nvim/parser/ocaml.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-ocaml}/parser";
      "${config.xdg.dataHome}/nvim/parser/python.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-python}/parser";
      "${config.xdg.dataHome}/nvim/parser/regex.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-regex}/parser";
      "${config.xdg.dataHome}/nvim/parser/rust.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-rust}/parser";
      "${config.xdg.dataHome}/nvim/parser/svelte.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-svelte}/parser";
      "${config.xdg.dataHome}/nvim/parser/scala.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-scala}/parser";
      "${config.xdg.dataHome}/nvim/parser/typescript.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-typescript}/parser";
      "${config.xdg.dataHome}/nvim/parser/yaml.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-yaml}/parser";
    };
  };
}
